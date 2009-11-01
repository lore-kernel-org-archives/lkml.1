Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbZKAW1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbZKAW1k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 17:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbZKAW1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 17:27:36 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38285 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbZKAW1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 17:27:32 -0500
Date: Sun, 1 Nov 2009 23:27:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>, Greg KH <greg@kroah.com>
Subject: [PATCH 3/3] staging/dream: Add final missing bits
Message-ID: <20091101222733.GC20740@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds final missing bits that allow drivers/staging to compile.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/staging/dream/include/mach/camera.h b/drivers/staging/dream/include/mach/camera.h
index c20f042..6ccc521 100644
--- a/drivers/staging/dream/include/mach/camera.h
+++ b/drivers/staging/dream/include/mach/camera.h
@@ -277,3 +277,39 @@ void msm_camio_disable(struct platform_device *);
 int msm_camio_probe_on(struct platform_device *);
 int msm_camio_probe_off(struct platform_device *);
 #endif
+
+struct msm_camera_io_ext {
+	uint32_t mdcphy;
+	uint32_t mdcsz;
+	uint32_t appphy;
+	uint32_t appsz;
+};
+
+struct msm_camera_device_platform_data {
+	void (*camera_gpio_on) (void);
+	void (*camera_gpio_off)(void);
+	struct msm_camera_io_ext ioext;
+};
+
+#ifdef CONFIG_SENSORS_MT9T013
+struct msm_camera_legacy_device_platform_data {
+	int sensor_reset;
+	int sensor_pwd;
+	int vcm_pwd;
+	void (*config_gpio_on) (void);
+	void (*config_gpio_off)(void);
+};
+#endif
+
+#define MSM_CAMERA_FLASH_NONE 0
+#define MSM_CAMERA_FLASH_LED  1
+
+struct msm_camera_sensor_info {
+	const char *sensor_name;
+	int sensor_reset;
+	int sensor_pwd;
+	int vcm_pwd;
+	int mclk;
+	int flash_type;
+	struct msm_camera_device_platform_data *pdata;
+};
diff --git a/drivers/staging/dream/include/mach/msm_rpcrouter.h b/drivers/staging/dream/include/mach/msm_rpcrouter.h
index 9724ece..2ad21de 100644
--- a/drivers/staging/dream/include/mach/msm_rpcrouter.h
+++ b/drivers/staging/dream/include/mach/msm_rpcrouter.h
@@ -176,4 +176,14 @@ struct msm_rpc_server
 
 int msm_rpc_create_server(struct msm_rpc_server *server);
 
+struct snd_endpoint {
+	int id;
+	const char *name;
+};
+
+struct msm_snd_endpoints {
+	struct snd_endpoint *endpoints;
+	unsigned num;
+};
+
 #endif
diff --git a/drivers/staging/dream/qdsp5/adsp.c b/drivers/staging/dream/qdsp5/adsp.c
index 9069535..1fab9ce 100644
--- a/drivers/staging/dream/qdsp5/adsp.c
+++ b/drivers/staging/dream/qdsp5/adsp.c
@@ -45,6 +45,7 @@ static inline void allow_suspend(void)
 #include "adsp.h"
 
 #define INT_ADSP INT_ADSP_A9_A11
+#define MSM_AD5_BASE          IOMEM(0xE0300000)
 
 static struct adsp_info adsp_info;
 static struct msm_rpc_endpoint *rpc_cb_server_client;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
