Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbZDOU5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbZDOU5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 16:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbZDOU5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 16:57:36 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:38622 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbZDOU5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 16:57:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=NgxD222OlPSAKD/7dcp1QYAUx8v+sMzDCxgpMjgsnNsAuX+Y4VjnV/ScD8NK+ic61n
         JvK0cYFrXDJUFERrVuxJh1DVld9zuVRaCguSnKhrlY5MrGZn9Krmz+SVHQrIm/7dDz7q
         viUfLoXkOFZWclPDUesqsK+0VvwLv+mP8FPQs=
Message-ID: <49E64A28.8070402@gmail.com>
Date: Wed, 15 Apr 2009 22:57:12 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       yakui_zhao <yakui.zhao@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: 2.6.30-rc1 (latest git): thinkpad-acpi: cannot control brightness
 with hotkeys (BISECTED)
References: <49E10684.5090101@gmail.com> <20090411150555.8b13ed18.akpm@linux-foundation.org> <20090412161448.GC26502@khazad-dum.debian.net> <49E234ED.5010105@gmail.com> <1239585695.5564.5.camel@localhost.localdomain> <49E3575A.60204@gmail.com> <20090413203450.GC16152@khazad-dum.debian.net> <49E5234E.5070303@gmail.com> <20090415164939.GA27807@srcf.ucam.org> <49E63BCB.9090801@gmail.com> <20090415200125.GA31483@srcf.ucam.org>
In-Reply-To: <20090415200125.GA31483@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2009 10:01 PM, Matthew Garrett wrote:
> On Wed, Apr 15, 2009 at 09:55:55PM +0200, Niel Lambrechts wrote:
>
>   
>> The behaviour seems slightly different from before your 74a365b3f354
>> commit in that /sys/class/backlight remains empty until i915 gets loaded
>> for the first time, the contents then persist even if i915 is unloaded.
>> Perhaps the directory was populated by a different kernel module, since
>> when I did the bisect yesterday the directory would be there on boot
>> before I started X or loaded i915.
>>     
>
> In the past the directory would be created when the acpi video driver 
> was loaded, but probably wouldn't work. Doing it that way is a violation 
> of the opregion spec and causes some machines to break in a horrible 
> manner, so I'd prefer not to go back to that version...
>   
Cool, I suspected it was intended behaviour... :)

So is there any chance of getting this fix merged any time soon (at
least before 2.6.30 is out)?

> If you use modesetting then you shouldn't need to launch X to get 
> working brightness control. The problem with the old-style world is that 
> you won't get interrupts until X comes up.

I'd love to use KMS, but I have no idea how to troubleshoot the freeze
I'm getting after the main gdm login screen. Or is there still a future
i915 milestone(s) to be reached before I can realistically do
i915.modeset=1, given the large amount of activity around this in recent
times?

Thanks for the help!
Niel
