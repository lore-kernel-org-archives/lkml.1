Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbYCZMIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbYCZMIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 08:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbYCZMIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 08:08:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53001 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbYCZMIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 08:08:46 -0400
Subject: Re: why so many unexported headers checking __KERNEL__?
From: David Woodhouse <dwmw2@infradead.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.00.0803230229530.1203@localhost.localdomain>
References: <alpine.LFD.1.00.0803230229530.1203@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 12:08:44 +0000
Message-Id: <1206533324.9540.268.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 (2.22.0-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-03-23 at 02:31 -0400, Robert P. J. Day wrote:
> 
>   as an unintended side effect of checking for proper exporting to
> user space and unifdef'ing, i noticed that there are literally
> hundreds of kernel header files that check the value of __KERNEL__ in
> some way, but are never exported to user space.  what's the point of
> that?  thanks.

There's no point -- we just haven't got round to removing it yet. 

We should probably make headers_check or some other automated check
catch these two cases:

If a header is exported by header-y or not exported at all, it shouldn't
contain any #ifdef __KERNEL__.

And if it's exported and doesn't contain any #ifdef __KERNEL__, it
should be header-y not unifdef-y (and that's the case we should be
moving towards, by cleaning up headers to have separate files for the
user-visible parts).

-- 
dwmw2

