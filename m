Return-Path: <linux-kernel-owner+w=401wt.eu-S1752237AbXC3Pmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbXC3Pmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 11:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbXC3Pmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 11:42:47 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:5377
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752237AbXC3Pmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 11:42:47 -0400
Message-Id: <460D4C35.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Fri, 30 Mar 2007 16:43:17 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix dependency generation
References: <460BA292.76E4.0078.0@novell.com>
 <20070330150843.GA3520@uranus.ravnborg.org>
In-Reply-To: <20070330150843.GA3520@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Sam Ravnborg <sam@ravnborg.org> 30.03.07 17:08 >>>
>On Thu, Mar 29, 2007 at 10:27:14AM +0100, Jan Beulich wrote:
>> Commit 2e3646e51b2d6415549b310655df63e7e0d7a080 changed the way
>> the split config tree is built, but failed to also adjust fixdep
>> accordingly - if changing a config option from or to m, files
>> referencing the respective CONFIG_..._MODULE (but not the
>> corresponding CONFIG_...) didn't get rebuilt.
>Do you have a test case for this?
>I want to play a little with this before I submit it.

On i386, set CONFIG_APM=y, build, then change it to m.

>> 
>> Once at it, also eliminate false dependencies due to use of
>> ...CONFIG_... identifiers.
>But that will break UM - no??
>See following note from fixdep:
> * Note 2: if somebody writes HELLO_CONFIG_BOOM in a file, it will depend onto
> * CONFIG_BOOM. This could seem a bug (not too hard to fix), but please do not
> * fix it! Some UserModeLinux files (look at arch/um/) call CONFIG_BOOM as
> * UML_CONFIG_BOOM, to avoid conflicts with /usr/include/linux/autoconf.h,
> * through arch/um/include/uml-config.h; this fixdep "bug" makes sure that
> * those files will have correct dependencies.

Hmm, didn't see this note. Then this might warrant special casing UML, but
penalizing all code due to this seems at least odd to me.

Jan
