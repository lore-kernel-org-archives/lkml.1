Return-Path: <linux-kernel-owner+w=401wt.eu-S1752589AbZHHNlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbZHHNlA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 09:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbZHHNk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 09:40:59 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33357 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZHHNk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 09:40:58 -0400
Date: Sat, 8 Aug 2009 15:40:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Trilok Soni <soni.trilok@gmail.com>, Greg KH <greg@kroah.com>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, dmitry.torokhov@gmail.com,
       dtor@mail.ru, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org
Subject: Synaptics touchscreen for HTC Dream: check that smbus is available
Message-ID: <20090808134049.GA13083@elf.ucw.cz>
References: <20090714100634.GA4054@elf.ucw.cz> <5d5443650907140320w334864f4uc1ee13ed32fdb874@mail.gmail.com> <20090715133627.GA2538@elf.ucw.cz> <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com> <20090721102153.GE4133@elf.ucw.cz> <5d5443650907210334k3f562cebsc665511a161c8639@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5d5443650907210334k3f562cebsc665511a161c8639@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Because this driver is using smbus i2c apis, it will be good to add
> >> that check too.
> >
> > So I should do something like
> >
> > if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_WORD_DATA))
> >        ...
> >
> > in addition?
> 
> Yes.

Ok, here it is.

--- 

Check that SMBUS APIs are available in touchscreen driver.
    
Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/staging/dream/synaptics_i2c_rmi.c b/drivers/staging/dream/synaptics_i2c_rmi.c
index dc1e3c7..6e23276 100644
--- a/drivers/staging/dream/synaptics_i2c_rmi.c
+++ b/drivers/staging/dream/synaptics_i2c_rmi.c
@@ -373,6 +373,12 @@ static int __devinit synaptics_ts_probe(
 		goto err_check_functionality_failed;
 	}
 
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
+		pr_err("synaptics_ts_probe: need I2C_FUNC_SMBUS_WORD_DATA\n");
+		ret = -ENODEV;
+		goto err_check_functionality_failed;
+	}
+
 	ts = kzalloc(sizeof(*ts), GFP_KERNEL);
 	if (ts == NULL) {
 		ret = -ENOMEM;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
