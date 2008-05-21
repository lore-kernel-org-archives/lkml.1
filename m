Return-Path: <linux-kernel-owner+w=401wt.eu-S1762221AbYEUFa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762221AbYEUFa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 01:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbYEUFaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 01:30:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38524 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbYEUFaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 01:30:14 -0400
Date: Wed, 21 May 2008 06:30:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, torvalds@linux-foundation.org,
       geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] provide out-of-line strcat() for m68k
Message-ID: <20080521053012.GL28946@ZenIV.linux.org.uk>
References: <E1JycsB-0000M9-36@ZenIV.linux.org.uk> <Pine.LNX.4.64.0805210531170.18184@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805210531170.18184@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 05:34:58AM +0200, Roman Zippel wrote:
> Hi,
> 
> On Wed, 21 May 2008, Al Viro wrote:
> 
> > Whether we sidestep it in init/main.c or not, such situations
> > will arise again; compiler does generate calls of strcat()
> > on optimizations, so we really ought to have an out-of-line
> > version...
> 
> It actually was strlen that was generated and not strcat.

Here it replaced strncat() with call of strcat() (gcc 4.0.1, FWIW).
And yes, I can show you init/main.s with
	jbsr strcat	|
in it generated on kernel in b0rken range...
