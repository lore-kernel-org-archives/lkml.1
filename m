Return-Path: <linux-kernel-owner+w=401wt.eu-S1755103AbYCEUO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbYCEUO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 15:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbYCEUOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 15:14:18 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:36136 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbYCEUOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 15:14:18 -0500
X-Greylist: delayed 658 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Mar 2008 15:14:18 EST
Date: Wed, 5 Mar 2008 11:58:34 -0800
From: Joe Buck <Joe.Buck@synopsys.COM>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Aurelien Jarno <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: Linux doesn't follow x86/x86-64 ABI wrt direction flag
Message-ID: <20080305195834.GA17267@synopsys.com>
References: <20080305153020.GA24631@volta.aurel32.net> <47CEC3AA.6080709@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CEC3AA.6080709@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Aurelien Jarno wrote:
> >Since version 4.3, gcc changed its behaviour concerning the x86/x86-64 
> >ABI and the direction flag, that is it now assumes that the direction 
> >flag is cleared at the entry of a function and it doesn't clear once 
> >more if needed.
> >...
> >I guess this has to be fixed on the kernel side, but also gcc-4.3 could
> >revert back to the old behaviour, that is clearing the direction flag
> >when entering a routine that touches it until most people are running a
> >fixed kernel.

On Wed, Mar 05, 2008 at 08:00:42AM -0800, H. Peter Anvin wrote:
> Linux should definitely follow the ABI.  This is a bug, and a pretty 
> serious such.

Unfortunately, there are a lot of kernels out there already with this
problem, and the symptoms are likely to be subtle.  So even if it is true
that it is the kernel that is "in the wrong", I think we still are going
to need to give users a workaround from the gcc side as well.

So I think gcc at least needs an *option* to revert to the old behavior,
and there's a good argument to make it the default for now, at least for
x86/x86-64 on Linux.




