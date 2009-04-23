Return-Path: <linux-kernel-owner+w=401wt.eu-S1757162AbZDWKXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbZDWKXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 06:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756564AbZDWKXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 06:23:19 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:53714 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822AbZDWKXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 06:23:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SekN38e3kNlrYpi7QNIHU2iX9Ng98E1GT5vkGUau22WGDdjYsDEYJ6j5DJZ1tBIhO/
         bZVC6WXOYxuSmL7jrjIzxhLifCixsaFhhpM3QArHCFmzUWs2xCgkrEjfKzSSi+l4O4Y0
         /oE6+wCt0E9pqhzqicypaQyCiSzlnDuAMEYNI=
Message-ID: <49F04192.6080300@gmail.com>
Date: Thu, 23 Apr 2009 12:23:14 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: fmhess@users.sourceforge.net, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, Ian Abbott <abbotti@mev.co.uk>,
       David Schleef <ds@schleef.org>
Subject: Re: staging: comedi: non working tests on unsigned cmd->convert_arg
References: <49EDC792.60100@gmail.com> <20090422165049.GC19524@kroah.com> <200904221411.13851.fmhess@speakeasy.net> <20090423020824.GA6083@kroah.com>
In-Reply-To: <20090423020824.GA6083@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Apr 22, 2009 at 02:11:10PM -0400, Frank Mori Hess wrote:
>> On Wednesday 22 April 2009, Greg KH wrote:
>>> On Tue, Apr 21, 2009 at 03:18:10PM +0200, Roel Kluin wrote:
>>>> vi drivers/staging/comedi/comedi.h +342
>>>>
>>>> and note that cmd->convert_arg in s626_ai_cmdtest() is unsigned.
>>>> Should there maybe be a test:
>>>>
>>>> if (cmd->convert_src == TRIG_EXT && cmd->convert_arg > MAX)
>>>>
>>>> (and what should MAX be then?)
>>> I don't know.  Let's ask the comedi developers :)
>>>
>>> Frank, what do you think about this?
>>
>> It looks like there already is such a test, right below the useless one the 
>> patch removes.
> 
> Ok, thanks for checking.  Roel, care to resend these patches then?
> 
> thanks,
> 
> greg k-h
> 
So you don't want to set cmd->*_arg to 0 when beyond 39 or below 0?
------------------------------>8-------------8<---------------------------------
Remove tests for negative unsigned.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com> 
---
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 30dec9d..a48b244 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -1886,31 +1886,16 @@ static int s626_ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s
 		err++;
 	}
 
-	if (cmd->start_src == TRIG_EXT && cmd->start_arg < 0) {
-		cmd->start_arg = 0;
-		err++;
-	}
-
 	if (cmd->start_src == TRIG_EXT && cmd->start_arg > 39) {
 		cmd->start_arg = 39;
 		err++;
 	}
 
-	if (cmd->scan_begin_src == TRIG_EXT && cmd->scan_begin_arg < 0) {
-		cmd->scan_begin_arg = 0;
-		err++;
-	}
-
 	if (cmd->scan_begin_src == TRIG_EXT && cmd->scan_begin_arg > 39) {
 		cmd->scan_begin_arg = 39;
 		err++;
 	}
 
-	if (cmd->convert_src == TRIG_EXT && cmd->convert_arg < 0) {
-		cmd->convert_arg = 0;
-		err++;
-	}
-
 	if (cmd->convert_src == TRIG_EXT && cmd->convert_arg > 39) {
 		cmd->convert_arg = 39;
 		err++;
