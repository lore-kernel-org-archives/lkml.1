Return-Path: <linux-kernel-owner+w=401wt.eu-S1757776AbZKCBgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbZKCBgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 20:36:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755716AbZKCBgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 20:36:03 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:57496 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578AbZKCBgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 20:36:02 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19183.35067.828412.651217@pilspetsen.it.uu.se>
Date: Tue, 3 Nov 2009 02:35:55 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: david@lang.hm
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Ryan C. Gordon" <icculus@icculus.org>,
       =?ISO-8859-15?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
In-Reply-To: <alpine.DEB.2.00.0911021205540.12321@asgard.lang.hm>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
	<1257103201.2865.6.camel@chumley>
	<yw1xy6mq0z2s.fsf@unicorn.mansr.com>
	<alpine.OSX.1.10.0911011540400.53392@caridad.local>
	<20091102000147.424f104b@lxorguk.ukuu.org.uk>
	<alpine.OSX.1.10.0911012023020.55434@caridad.local>
	<20091102091611.60dfeea1@lxorguk.ukuu.org.uk>
	<alpine.DEB.2.00.0911020936500.12321@asgard.lang.hm>
	<m3eioghf9n.fsf@intrepid.localdomain>
	<alpine.DEB.2.00.0911021205540.12321@asgard.lang.hm>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm writes:
 > > FatELF means you have to compile for many archs. Do you even have the
 > > necessary compilers? Extra time and disk space used for what, to solve
 > > a non-problem?
 > 
 > you don't have to compile multiple arches anymore than you have to provide 
 > any other support for that arch. FatELF is a way to bundle the binaries 
 > that you were already creating, not something to force you to support an 
 > arch you otherwise wouldn't (although if it did make it easy enough for 
 > you to do so that you started to support additional arches, that would be 
 > a good thing)

'bundle' by gluing .o files together rather than using what we already have:
directories, search paths, $VARIABLES in search paths, and ELF interpreters
and .so loaders that know to look in $ARCH subdirectories first (I used that
feature to perform an incremental upgrade from OABI to EABI on my ARM/Linux
systems last winter).

Someone, somewhere, has to inspect $ARCH and make a decision. Moving that
decision from user-space to kernel-space for ELF file loading is neither
necessary nor sufficient. Consider .a and .h files for instance.

 > > I'm surprised this idea made it here. It certainly has merit for
 > > installation medium, but it's called directory tree and/or .tar or .zip
 > > there.
 > 
 > if you have a 1M binary with 500M data, repeated for 5 arches it is not a 
 > win vs a single 505M FatELF package in all cases.

If I have a 1M binary with 500M non-arch data I'll split the package because
I'm not a complete moron.

IMNSHO FatELF is a technology pretending to be a solution to "problems"
that don't exist or have user-space solutions. Either way, it doesn't
belong in the Linux kernel.
