Return-Path: <linux-kernel-owner+w=401wt.eu-S1765317AbYB0DAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765317AbYB0DAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 22:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbYB0DAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 22:00:42 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:59179 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbYB0DAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 22:00:41 -0500
Date: Wed, 27 Feb 2008 03:59:45 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Sam Ravnborg <sam@ravnborg.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kiran@scalemp.com, shai@scalemp.com, Glauber Costa <gcosta@redhat.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: Kconfig configuration restore bug [Was: x86: vSMP selection in
 config]
In-Reply-To: <20080226194058.GA31438@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0802270353480.2723@scrub.home>
References: <200802210258.45011.yinghai.lu@sun.com> <200802241832.37850.yinghai.lu@sun.com>
 <200802242136.28744.yinghai.lu@sun.com> <200802242243.49576.yinghai.lu@sun.com>
 <20080226194058.GA31438@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 26 Feb 2008, Sam Ravnborg wrote:

> choice
> 	prompt "Subarchitecture Type"
> 
> config X86_PC
> 	bool "PC-compatible"
> 
> config X86_VOYAGER
> 	bool "Voyager (NCR)"
> 
> config X86_VSMP
> 	bool "Support for ScaleMP vSMP"
> 	depends on PCI
> 
> endchoice
> 
> config PCI
> 	bool "PCI support" if !X86_VISWS
> 	depends on !X86_VOYAGER
> 	default y

The basic problem is that this is a recursive dependency - PCI depends on 
the choice and the choice depends on PCI. IMO X86_VSMP cannot depend on 
PCI.
I'm looking into why this hasn't been picked up by the dependency check...

bye, Roman
