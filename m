Return-Path: <linux-kernel-owner+w=401wt.eu-S964819AbZGQSHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964819AbZGQSHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 14:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933583AbZGQSHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 14:07:21 -0400
Received: from cobra.newdream.net ([66.33.216.30]:58278 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934069AbZGQSHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 14:07:20 -0400
Date: Fri, 17 Jul 2009 11:07:20 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/20] ceph: debugging
In-Reply-To: <Pine.LNX.4.64.0907161014330.8026@cobra.newdream.net>
Message-ID: <Pine.LNX.4.64.0907171010470.23194@cobra.newdream.net>
References: <1247693090-27796-1-git-send-email-sage@newdream.net>
 <1247693090-27796-5-git-send-email-sage@newdream.net>
 <1247693090-27796-6-git-send-email-sage@newdream.net>
 <1247693090-27796-7-git-send-email-sage@newdream.net>
 <1247693090-27796-8-git-send-email-sage@newdream.net>
 <1247693090-27796-9-git-send-email-sage@newdream.net>
 <1247693090-27796-10-git-send-email-sage@newdream.net>
 <1247693090-27796-11-git-send-email-sage@newdream.net>
 <1247693090-27796-12-git-send-email-sage@newdream.net>
 <1247693090-27796-13-git-send-email-sage@newdream.net>
 <1247693090-27796-14-git-send-email-sage@newdream.net>
 <1247693090-27796-15-git-send-email-sage@newdream.net>
 <1247693090-27796-16-git-send-email-sage@newdream.net>
 <1247693090-27796-17-git-send-email-sage@newdream.net>
 <1247693090-27796-18-git-send-email-sage@newdream.net>
 <1247693090-27796-19-git-send-email-sage@newdream.net> <87d480x16p.fsf@basil.nowhere.org>
 <Pine.LNX.4.64.0907161014330.8026@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 16 Jul 2009, Andi Kleen wrote:
> > Sage Weil <sage@newdream.net> writes:
> > 
> > > Some debugging infrastructure, including the ability to adjust the
> > > level of debug output on a per-file basis.
> > 
> > That is already provided by pr_debug()/DYNAMIC_PRINTK in newer kernels.
> > You should switch to that.

I'll spare everyone the diff, but

 19 files changed, 721 insertions(+), 1107 deletions(-)

and ceph_debug.h is now just a wrapper to prefix each line with a filename 
and line number (below).

Thanks-
sage

---
#ifndef _FS_CEPH_DEBUG_H
#define _FS_CEPH_DEBUG_H

/*
 * wrap pr_debug to include a filename:lineno prefix on each line
 */

static inline const char *ceph_file_part(const char *s, int len)
{
	const char *e = s + len;

	while (e != s && *(e-1) != '/')
		e--;
	return e;
}

#define _dout(fmt, args...)						\
	pr_debug(" %12.12s:%-4d : " fmt "%s",				\
		 ceph_file_part(__FILE__, sizeof(__FILE__)),		\
		 __LINE__, args);
#define dout(args...) _dout(args, "")


#endif
