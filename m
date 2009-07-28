Return-Path: <linux-kernel-owner+w=401wt.eu-S1752787AbZG1Xjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbZG1Xjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZG1Xje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:39:34 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:42876 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbZG1Xjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:39:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Wd6QsymMmB7n4ixbxmI4Jhvx4V4csQMeDjxalYg5Heww22WhItgQg/27K7dIsfOkEK
         R8oNMa2PHpEL5LvI9/Mgj1XU5xuV7Bmq6a2+sIcvef5jPFjKzQ/oWJY+qX/9FJdaXcT3
         gG2X/MXWDngv3jDlzE43Pwoex65z8h81274bY=
Subject: Re: [PATCH 1/1] acer-wmi: switch driver to dev_pm_ops
From: Arnaud Faucher <arnaud.faucher@gmail.com>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Frans Pop <elendil@planet.nl>,
       Manuel Lauss <manuel.lauss@gmail.com>, Erik Ekman <erik@kryo.se>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1248648663.3718.7.camel@green>
References: <1248527091-18246-1-git-send-email-arnaud.faucher@gmail.com>
	 <200907261523.30378.carlos@strangeworlds.co.uk>
	 <20090726180809.GA31396@dtor-d630.eng.vmware.com>
	 <200907261935.08762.carlos@strangeworlds.co.uk>
	 <1248640128.4216.13.camel@green>
	 <EF5CB084-D774-49E3-9E9F-6803ECB9862C@gmail.com>
	 <1248648663.3718.7.camel@green>
Content-Type: text/plain
Date: Tue, 28 Jul 2009 19:39:27 -0400
Message-Id: <1248824367.4112.31.camel@green>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 26, 2009 at 18:51 -0400, Arnaud Faucher wrote :
> On dim, 2009-07-26 at 14:33 -0700, Dmitry Torokhov wrote:
> > On Jul 26, 2009, at 1:28 PM, Arnaud Faucher <arnaud.faucher@gmail.com>  
> > wrote:
> > 
> > > On dim, 2009-07-26 at 19:35 +0100, Carlos Corbacho wrote:
> > >> On Sunday 26 July 2009 19:08:09 Dmitry Torokhov wrote:
> > >>> On Sun, Jul 26, 2009 at 03:23:29PM +0100, Carlos Corbacho wrote:
> > >>>> [Removing linux-mips from CC - I don't know why they'd be  
> > >>>> interested in
> > >>>> an x86 only platform driver...]
> > >>>>
> > >>>> On Sunday 26 July 2009 14:53:33 Arnaud Faucher wrote:
> > >>>>> Gets rid of the following warning:
> > >>>>> Platform driver 'acer-wmi' needs updating - please use dev_pm_ops
> > >>>>>
> > >>>>> Take 2, thanks to Dmitry, Rafael and Frans for pointing out PM  
> > >>>>> issue on
> > >>>>> hibernation when using dev_pm_ops blindly.
> > >>>>>
> > >>>>> This patch was tested against suspendand hibernation (Acer mail  
> > >>>>> led
> > >>>>> status).
> > >>>>>
> > >>>>> Signed-off-by: Arnaud Faucher <arnaud.faucher@gmail.com>
> > >>>>> ---
> > >>>>> drivers/platform/x86/acer-wmi.c |   17 ++++++++++++-----
> > >>>>> 1 files changed, 12 insertions(+), 5 deletions(-)
> > >>>>>
> > >>>>> diff --git a/drivers/platform/x86/acer-wmi.c
> > >>>>> b/drivers/platform/x86/acer-wmi.c
> > >>>>> index be2fd6f..29374bc 100644
> > >>>>> --- a/drivers/platform/x86/acer-wmi.c
> > >>>>> +++ b/drivers/platform/x86/acer-wmi.c
> > >>>>> @@ -1152,8 +1152,7 @@ static int acer_platform_remove(struct
> > >>>>> platform_device *device)
> > >>>>>    return 0;
> > >>>>> }
> > >>>>>
> > >>>>> -static int acer_platform_suspend(struct platform_device *dev,
> > >>>>> -pm_message_t state)
> > >>>>> +static int acer_platform_suspend(struct device *dev)
> > >>>>> {
> > >>>>>    u32 value;
> > >>>>>    struct acer_data *data = &interface->data;
> > >>>>> @@ -1174,7 +1173,7 @@ pm_message_t state)
> > >>>>>    return 0;
> > >>>>> }
> > >>>>>
> > >>>>> -static int acer_platform_resume(struct platform_device *device)
> > >>>>> +static int acer_platform_resume(struct device *dev)
> > >>>>> {
> > >>>>>    struct acer_data *data = &interface->data;
> > >>>>>
> > >>>>> @@ -1190,15 +1189,23 @@ static int acer_platform_resume(struct
> > >>>>> platform_device *device)
> > >>>>>    return 0;
> > >>>>> }
> > >>>>>
> > >>>>> +static struct dev_pm_ops acer_platform_pm_ops = {
> > >>>>> +    .suspend = acer_platform_suspend,
> > >>>>> +    .resume = acer_platform_resume,
> > >>>>
> > >>>> Are these necessary? For suspend-to-RAM, I've never needed these.  
> > >>>> The old
> > >>>> callbacks here were just for suspend-to-disk.
> > >>>
> > >>> That is not correct. Old suspend and resume callbacks were called  
> > >>> for
> > >>> both S2R and S2D. Whether it is actually needed for S2R I don't  
> > >>> know but
> > >>> looking at the code they should not hurt.
> > >>
> > >> I'm aware they were called for S2RAM as well, but that was just a  
> > >> limitation
> > >> of the old calls - as I say, they're not needed for it (at least on  
> > >> my
> > >> hardware anyway).
> > >>
> > >
> > > I was looking for similar functionality.
> > >
> > >>>>> +    .freeze = acer_platform_suspend,
> > >>>>> +    .thaw = acer_platform_resume,
> > >>>>
> > >>>> If we only need these callbacks for freeze & thaw, they should be
> > >>>> rebamed.
> > >>>>
> > >>>>> +    .poweroff = acer_platform_suspend,
> > >>>>> +    .restore = acer_platform_resume,
> > >>>>
> > >>>> What do poweroff and restore mean in this context. Do my comments  
> > >>>> above
> > >>>> apply again (i.e. are the callbacks necessary here)?
> > >>>
> > >>> I don't think poweroff handler is needed.
> > >
> > > After testing many combinations, I observed that I had to use that  
> > > much
> > > callbacks. For example, when omitting to wire .poweroff/.restore,
> > > with .freeze/.thaw linked to suspend()/resume(), the state (of the  
> > > mail
> > > led) is not restored correctly after S2D.
> > 
> > 
> > Have you tried with just 3 - freeze, thaw and restore?
> > 
> 
> State restoration seems to be OK with only those three ones (tested
> against both S2RAM and S2D on my Acer Aspire 5680).
> 
> BTW, in the "struct dev_pm_ops" documentation, it would be interesting
> to know which callback sequence occurs in case of S2RAM and S2D events.
> 
> 

Here are my observations regarding PM events and callbacks:

S2RAM ("Suspend"):
event trigged -> .suspend gets called
recover from S2RAM -> .resume gets called
For *this module*, these callbacks seem not necessary, because the state
of hardware seems to be automatically restored on resume from S2RAM (by
BIOS ???).

S2DISK ("Hibernation"):
event trigged -> .freeze, then .thaw gets called
recover from S2DISK -> .restore gets called
As per the pm.h documentation .thaw is called after RAM image has been
created, in order to restore hardware state in case RAM image failed and
the system cannot power off. So this callback should be linked to
something similar to the .restore callback. For *this module*, though it
may not be necessary because the state of both LCD backlight and mail
LED persist after RAM image creation, I have linked this callback
anyway.

After around 2 days of testing, here is a third attempt for this patch.
Please note that I renamed the functions to better reflect their use.
Can you please stress it ?

Signed-off-by: Arnaud Faucher <arnaud.faucher@gmail.com>
---
 drivers/platform/x86/acer-wmi.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c
b/drivers/platform/x86/acer-wmi.c
index fb45f5e..331771d 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -1152,8 +1152,7 @@ static int acer_platform_remove(struct
platform_device *device)
 	return 0;
 }
 
-static int acer_platform_suspend(struct platform_device *dev,
-pm_message_t state)
+static int acer_platform_freeze(struct device *dev)
 {
 	u32 value;
 	struct acer_data *data = &interface->data;
@@ -1174,7 +1173,7 @@ pm_message_t state)
 	return 0;
 }
 
-static int acer_platform_resume(struct platform_device *device)
+static int acer_platform_restore(struct device *dev)
 {
 	struct acer_data *data = &interface->data;
 
@@ -1190,15 +1189,20 @@ static int acer_platform_resume(struct
platform_device *device)
 	return 0;
 }
 
+static struct dev_pm_ops acer_platform_pm_ops = {
+	.freeze = acer_platform_freeze,
+	.thaw = acer_platform_restore,
+	.restore = acer_platform_restore,
+};
+
 static struct platform_driver acer_platform_driver = {
 	.driver = {
 		.name = "acer-wmi",
 		.owner = THIS_MODULE,
+		.pm = &acer_platform_pm_ops,
 	},
 	.probe = acer_platform_probe,
 	.remove = acer_platform_remove,
-	.suspend = acer_platform_suspend,
-	.resume = acer_platform_resume,
 };
 
 static struct platform_device *acer_platform_device;
-- 
1.6.3.3


