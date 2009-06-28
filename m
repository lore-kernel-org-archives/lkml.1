Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbZF1VTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbZF1VTh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 17:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZF1VT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 17:19:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38550 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbZF1VT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 17:19:27 -0400
Date: Sun, 28 Jun 2009 23:19:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: HTC Dream: framebuffer checkpatch cleanups
Message-ID: <20090628211920.GA2198@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix checkpatch warnings in drivers/video/msm. Fairly minor stuff.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/video/msm/mddi.c b/drivers/video/msm/mddi.c
index adc559e..e0bd6d6 100644
--- a/drivers/video/msm/mddi.c
+++ b/drivers/video/msm/mddi.c
@@ -481,7 +481,7 @@ static int __init mddi_get_client_caps(struct mddi_info *mddi)
 		printk(KERN_INFO KERN_ERR "mddi_init, timeout waiting for "
 				"caps\n");
 	}
-	return (mddi->flags & FLAG_HAVE_CAPS);
+	return mddi->flags & FLAG_HAVE_CAPS;
 }
 
 /* link must be active when this is called */
diff --git a/drivers/video/msm/mddi_client_nt35399.c b/drivers/video/msm/mddi_client_nt35399.c
index 4cae4fd..9c78050 100644
--- a/drivers/video/msm/mddi_client_nt35399.c
+++ b/drivers/video/msm/mddi_client_nt35399.c
@@ -34,7 +34,7 @@ struct panel_info {
 	int nt35399_got_int;
 };
 
-static void 
+static void
 nt35399_request_vsync(struct msm_panel_data *panel_data,
 		      struct msmfb_callback *callback)
 {
@@ -54,13 +54,13 @@ static void nt35399_wait_vsync(struct msm_panel_data *panel_data)
 	struct panel_info *panel = container_of(panel_data, struct panel_info,
 						panel_data);
 	struct msm_mddi_client_data *client_data = panel->client_data;
-	
+
 	if (panel->nt35399_got_int) {
 		panel->nt35399_got_int = 0;
 		client_data->activate_link(client_data); /* clears interrupt */
 	}
 
-	if (wait_event_timeout(nt35399_vsync_wait, panel->nt35399_got_int, 
+	if (wait_event_timeout(nt35399_vsync_wait, panel->nt35399_got_int,
 				HZ/2) == 0)
 		printk(KERN_ERR "timeout waiting for VSYNC\n");
 
@@ -77,7 +77,7 @@ static int nt35399_suspend(struct msm_panel_data *panel_data)
 	struct msm_mddi_bridge_platform_data *bridge_data =
 		client_data->private_client_data;
 	int ret;
-	
+
 	ret = bridge_data->uninit(bridge_data, client_data);
 	if (ret) {
 		printk(KERN_INFO "mddi nt35399 client: non zero return from "
@@ -132,7 +132,7 @@ irqreturn_t nt35399_vsync_interrupt(int irq, void *data)
 	struct panel_info *panel = data;
 
 	panel->nt35399_got_int = 1;
-	
+
 	if (panel->fb_callback) {
 		panel->fb_callback->func(panel->fb_callback);
 		panel->fb_callback = NULL;
@@ -164,12 +164,12 @@ static int setup_vsync(struct panel_info *panel, int init)
 	ret = irq = gpio_to_irq(gpio);
 	if (ret < 0)
 		goto err_get_irq_num_failed;
-	
+
 	ret = request_irq(irq, nt35399_vsync_interrupt, IRQF_TRIGGER_RISING,
 			  "vsync", panel);
 	if (ret)
 		goto err_request_irq_failed;
-	
+
 	printk(KERN_INFO "vsync on gpio %d now %d\n",
 	       gpio, gpio_get_value(gpio));
 	return 0;
@@ -187,17 +187,16 @@ err_request_gpio_failed:
 static int mddi_nt35399_probe(struct platform_device *pdev)
 {
 	struct msm_mddi_client_data *client_data = pdev->dev.platform_data;
-	struct msm_mddi_bridge_platform_data *bridge_data = 
+	struct msm_mddi_bridge_platform_data *bridge_data =
 		client_data->private_client_data;
 
 	int ret;
 
-	struct panel_info *panel = kzalloc(sizeof(struct panel_info), 
+	struct panel_info *panel = kzalloc(sizeof(struct panel_info),
 					   GFP_KERNEL);
-	
+
 	printk(KERN_DEBUG "%s: enter.\n", __func__);
-	
-	
+
 	if (!panel)
 		return -ENOMEM;
 	platform_set_drvdata(pdev, panel);
@@ -223,7 +222,7 @@ static int mddi_nt35399_probe(struct platform_device *pdev)
 	panel->pdev.resource = client_data->fb_resource;
 	panel->pdev.num_resources = 1;
 	panel->pdev.dev.platform_data = &panel->panel_data;
-	
+
 	if (bridge_data->init)
 		bridge_data->init(bridge_data, client_data);
 
@@ -249,7 +248,6 @@ static struct platform_driver mddi_client_0bda_8a47 = {
 
 static int __init mddi_client_nt35399_init(void)
 {
-	printk("+%s()\n",__FUNCTION__);
 	return platform_driver_register(&mddi_client_0bda_8a47);
 }
 
diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
index 475e02e..99636a2 100644
--- a/drivers/video/msm/mdp.c
+++ b/drivers/video/msm/mdp.c
@@ -256,7 +256,7 @@ void mdp_dma(struct mdp_device *mdp_dev, uint32_t addr, uint32_t stride,
 
 int get_img(struct mdp_img *img, struct fb_info *info,
 	    unsigned long *start, unsigned long *len,
-	    struct file** filep)
+	    struct file **filep)
 {
 	int put_needed, ret = 0;
 	struct file *file;
diff --git a/drivers/video/msm/mdp_ppp.c b/drivers/video/msm/mdp_ppp.c
index ef52769..ba2c467 100644
--- a/drivers/video/msm/mdp_ppp.c
+++ b/drivers/video/msm/mdp_ppp.c
@@ -507,7 +507,7 @@ static void blit_blur(const struct mdp_info *mdp, struct mdp_blit_req *req,
 		return;
 
 	if (!(downscale_x_table == MDP_DOWNSCALE_BLUR &&
-              downscale_y_table == MDP_DOWNSCALE_BLUR)) {
+	      downscale_y_table == MDP_DOWNSCALE_BLUR)) {
 		load_scale_table(mdp, mdp_gaussian_blur_table, 128);
 		downscale_x_table = MDP_DOWNSCALE_BLUR;
 		downscale_y_table = MDP_DOWNSCALE_BLUR;
diff --git a/drivers/video/msm/mdp_scale_tables.c b/drivers/video/msm/mdp_scale_tables.c
index 188a71c..604783b 100644
--- a/drivers/video/msm/mdp_scale_tables.c
+++ b/drivers/video/msm/mdp_scale_tables.c
@@ -351,11 +351,11 @@ static struct mdp_table_entry mdp_downscale_x_table_PT8TO1[] = {
 	{ 0x502fc,  0x34003fe },
 };
 
-struct mdp_table_entry* mdp_downscale_x_table[MDP_DOWNSCALE_MAX] = {
-	[ MDP_DOWNSCALE_PT2TOPT4] = mdp_downscale_x_table_PT2TOPT4,
-	[ MDP_DOWNSCALE_PT4TOPT6] = mdp_downscale_x_table_PT4TOPT6,
-	[ MDP_DOWNSCALE_PT6TOPT8] = mdp_downscale_x_table_PT6TOPT8,
-	[ MDP_DOWNSCALE_PT8TO1]  = mdp_downscale_x_table_PT8TO1,
+struct mdp_table_entry *mdp_downscale_x_table[MDP_DOWNSCALE_MAX] = {
+	[MDP_DOWNSCALE_PT2TOPT4] = mdp_downscale_x_table_PT2TOPT4,
+	[MDP_DOWNSCALE_PT4TOPT6] = mdp_downscale_x_table_PT4TOPT6,
+	[MDP_DOWNSCALE_PT6TOPT8] = mdp_downscale_x_table_PT6TOPT8,
+	[MDP_DOWNSCALE_PT8TO1]  = mdp_downscale_x_table_PT8TO1,
 };
 
 static struct mdp_table_entry mdp_downscale_y_table_PT2TOPT4[] = {
@@ -627,10 +627,10 @@ static struct mdp_table_entry mdp_downscale_y_table_PT8TO1[] = {
 };
 
 struct mdp_table_entry *mdp_downscale_y_table[MDP_DOWNSCALE_MAX] = {
-	[ MDP_DOWNSCALE_PT2TOPT4] = mdp_downscale_y_table_PT2TOPT4,
-	[ MDP_DOWNSCALE_PT4TOPT6] = mdp_downscale_y_table_PT4TOPT6,
-	[ MDP_DOWNSCALE_PT6TOPT8] = mdp_downscale_y_table_PT6TOPT8,
-	[ MDP_DOWNSCALE_PT8TO1]  = mdp_downscale_y_table_PT8TO1,
+	[MDP_DOWNSCALE_PT2TOPT4] = mdp_downscale_y_table_PT2TOPT4,
+	[MDP_DOWNSCALE_PT4TOPT6] = mdp_downscale_y_table_PT4TOPT6,
+	[MDP_DOWNSCALE_PT6TOPT8] = mdp_downscale_y_table_PT6TOPT8,
+	[MDP_DOWNSCALE_PT8TO1]  = mdp_downscale_y_table_PT8TO1,
 };
 
 struct mdp_table_entry mdp_gaussian_blur_table[] = {

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
