Return-Path: <linux-kernel-owner+w=401wt.eu-S932422AbYCDSky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbYCDSky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763719AbYCDSkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:40:42 -0500
Received: from c-67-188-67-135.hsd1.ca.comcast.net ([67.188.67.135]:33842 "EHLO
	freya" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757843AbYCDSkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:40:41 -0500
Date: Tue, 4 Mar 2008 10:40:09 -0800
From: "Adam J. Richter" <adam@yggdrasil.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Patch: romfs_lookup always failed in linux-2.6.25-rc3-git3
Message-ID: <20080304184009.GB24301@freya.fugue.com>
References: <20080303173620.GA9243@freya.fugue.com> <5368.1204641163@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5368.1204641163@redhat.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 02:32:43PM +0000, David Howells wrote:
> [...] Can you look over the attached patch as an alternative, please?

	Your new goto labels "error" and "success" (instead of "out"
and "out0") clarify the code enough to justify your removal of the
comment block, so that's all good.  My only question is why you've
changed res from int to long, given that you've corrected my misguided
"P.S.":

> Adam J. Richter <adam@yggdrasil.com> wrote:
[...]
> > P.S. romfs_lookup casts a valid pointer to an int and then back again
> > with res = PTR_ERR(inode);...return ERR_PTR(res).  This may break on
> > arhictectures where sizeof(int) < sizeof(pointer).
> 
> This is not true.  [...]

	You're right.  My mistake.  Sorry for causing confusion.  But,
based on what you've just said, it doesn't sound like you need to
change res from int to long.  Is there some other issue I'm missing?

	Anyhow, if you want to do these changes together in a single
commit or separately, I'm fine with it either way.

Adam Richter
