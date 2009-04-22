Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbZDVAlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbZDVAlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 20:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbZDVAlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 20:41:09 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:47518 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbZDVAlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 20:41:08 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Apr 2009 20:41:06 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=sRYOoZaIPIQDIAdiijk1/IQW3vvzr9mJiZ90RMZkZFhugd6U0u7fcsXQmfU5qy7M4u
         3urusKtVVf1X/32Dk7xjJmaCjVQ+dTo70bAfOB2+u7XtjYfW3dOkzEKcqD/451sFpTPD
         yuBCFhwA7HSitNcx1vf7RnZMW4e5LKjRPT64M=
Message-ID: <49EE660E.7040907@gmail.com>
Date: Tue, 21 Apr 2009 18:34:22 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: =?UTF-8?B?Um9nw6lyaW8gQnJpdG8=?= <rbrito@ime.usp.br>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [2.6.30-rc2] usb reset during big file transfer and ext3 error
References: <20090421111015.GA30260@ime.usp.br>
In-Reply-To: <20090421111015.GA30260@ime.usp.br>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(ccing linux-usb)

Rogério Brito wrote:
> Hi there.
> 
> I have an amd64 system running Debian's sid distribution and I installed
> Linux 2.6.30-rc2 on it, as a way to get improvements for the i915
> subsystem.
> 
> Unfortunately, when I was transferring the contents of 2 DVDs from the
> main IDE HD to a USB external HD, I got errors from the USB host, the
> writes on the external HD become failures and the ext3 filesystem there
> enters into error mode, going read-only.
> 
> I eventually lose the access to the device (i.e., the /dev/sd??? device
> isn't there anymore) and I then have to re-run fsck on the given
> filesystem.
> 
> This has already happened 2 or 3 times already and I observed that it
> only occurs when there is high traffic---if I am, say, compiling the
> kernel on that external HD, I don't see any problems.
> 
> Attached is part of the dmesg log that shows the problem. I put the
> whole dmesg at <http://rb.doesntexist.org/linux/>.
> 
> As always, if any further information is needed, please let me know.

You're seeing these:

[103051.265045] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 
retry 1
[103051.265156] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 
retry 2
[103051.265281] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 
retry 3
[103051.265406] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 
retry 4

According to the EHCI spec, XactErr is "Set to a one by the Host 
Controller during status update in the case where the host did not 
receive a valid response from the device (Timeout, CRC, Bad PID, etc.)"

Quite likely this is some kind of hardware problem - maybe the USB port 
doesn't quite provide enough power for the drive, etc. A lot of these 
USB enclosure devices are also rather poor quality in general..
