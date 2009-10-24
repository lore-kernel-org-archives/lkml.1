Return-Path: <linux-kernel-owner+w=401wt.eu-S1751464AbZJXQof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbZJXQof (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 12:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbZJXQoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 12:44:34 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:59195 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbZJXQoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 12:44:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=w3DwCu93AsAsA8oAiDyocAuf7Vnt3XgVbkMvgBth5xCmm1qroXfVyVRwGoV14bGNzl
         F3rccKu2tC7a3daKA9C8RBLeRRKj+jBpyERjtOs1Y/uMIDWK6fBnMmbdRsCZBWoIipvN
         YSH/6Kc7uYdB8BVCC/1dVKxaIejdo8dewP2+c=
Message-ID: <4AE32EF2.2040508@googlemail.com>
Date: Sat, 24 Oct 2009 18:44:34 +0200
From: Gonsolo <gonsolo@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.4pre) Gecko/20090915 Thunderbird/3.0b4
MIME-Version: 1.0
To: mchehab@infradead.org, pboettcher@dibcom.fr
CC: linux-media@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: DVB-T dib0700 one minute hang when resuming
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

The following script fixes an annoying 62 second hang when resuming 
while my Nova-T stick is connected to my notebook.

echo /etc/pm/sleep.d/50_dvb_usb_dib0700_quirk:

#!/bin/sh

case "$1" in
  hibernate|suspend)
   rmmod dvb_usb_dib0700
   ;;
  thaw|resume)
   modprobe dvb_usb_dib0700
   ;;
  *) exit $NA
   ;;
esac

Is the right fix to use request_firmware_nowait?

Thank you.
