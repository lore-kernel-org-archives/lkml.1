Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbZDOMfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbZDOMfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 08:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755832AbZDOMf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 08:35:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54120 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbZDOMf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 08:35:26 -0400
Subject: Re: 2.6.30-rc1 (latest git): thinkpad-acpi: cannot control
 brightness with hotkeys (BISECTED)
From: Peter Zijlstra <peterz@infradead.org>
To: Niel Lambrechts <niel.lambrechts@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>,
       "Zhao, Yakui" <yakui.zhao@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <49E58460.1010402@gmail.com>
References: <49E10684.5090101@gmail.com>
	 <20090411150555.8b13ed18.akpm@linux-foundation.org>
	 <20090412161448.GC26502@khazad-dum.debian.net> <49E234ED.5010105@gmail.com>
	 <1239585695.5564.5.camel@localhost.localdomain> <49E3575A.60204@gmail.com>
	 <20090413203450.GC16152@khazad-dum.debian.net> <49E5234E.5070303@gmail.com>
	 <1239760242.7661.305.camel@rzhang-dt> <49E58460.1010402@gmail.com>
Content-Type: text/plain
Date: Wed, 15 Apr 2009 14:35:15 +0200
Message-Id: <1239798915.22720.2344.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-15 at 08:53 +0200, Niel Lambrechts wrote:
> On 04/15/2009 03:50 AM, Zhang Rui wrote:
> > On Wed, 2009-04-15 at 07:59 +0800, Niel Lambrechts wrote:
> >   
> >> On 04/13/2009 10:34 PM, Henrique de Moraes Holschuh wrote:
> >>     
> >>> On Mon, 13 Apr 2009, Niel Lambrechts wrote:
> >>>   
> >>>       
> >>>>>> In 2.6.29.1:
> >>>>>> lrwxrwxrwx 1 root root 0 Apr 12 20:01 /sys/class/backlight/acpi_video0
> >>>>>> -> ../../devices/virtual/backlight/acpi_video0
> >>>>>>         
> >>>>>>             
> >>> Well, that at least confirms that thinkpad-acpi doesn't have anything to
> >>> do with your troubles, you were using acpi video.
> >>>   
> >>>       
> >> Okay, I've bisected it to:
> >>
> >> 74a365b3f354fafc537efa5867deb7a9fadbfe27 is first bad commit
> >> commit 74a365b3f354fafc537efa5867deb7a9fadbfe27
> >> Author: Matthew Garrett <mjg59@srcf.ucam.org>
> >> Date:   Thu Mar 19 21:35:39 2009 +0000
> >>
> >>     ACPI: Populate DIDL before registering ACPI video device on Intel
> >>
> >>     
> >
> > please set CONFIG_DRM_I915_KMS, reload the ACPI video driver after
> > loading i915 and see if it helps.
> >   
> In all the kernels I've tried (up to 2.6.30-rc2), I get issues with KMS:
> 
> I boot with 'modeset=1 i915=1', console login is okay and 'modprobe i915
> modeset=1' seems to work - the console resolution changes (very small
> 1920x1200).

Hehe, at least you get something, I consistently get a black screen
whenever KMS gets enabled in a config.



