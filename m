Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbYCXVrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbYCXVrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 17:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYCXVrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 17:47:23 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:42051 "EHLO
	QMTA08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752644AbYCXVrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 17:47:22 -0400
X-Authority-Analysis: v=1.0 c=1 a=bF9fCXb2cRsA:10 a=i-A1-PYBjlTJk9g3afoA:9
 a=oyQz1oxJ7ixswW4EaV2M9BSdLzsA:4 a=si9q_4b84H0A:10 a=WuK_CZDBSqoA:10
Subject: Re: [PATCH prototype] [0/8] Predictive bitmaps for ELF executables
From: Nicholas Miell <nmiell@comcast.net>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <a36005b50803241242r2a9b38c5s57d9ac6b084021fa@mail.gmail.com>
References: <20080318104437.966c10ec.akpm@linux-foundation.org>
	 <20080320090005.GA25734@one.firstfloor.org>
	 <a36005b50803211015l64005f6emb80dbfc21dcfad9f@mail.gmail.com>
	 <20080321172644.GG2346@one.firstfloor.org>
	 <a36005b50803212136s78dc2e4bx5ac715ebc7a6e48a@mail.gmail.com>
	 <20080322071755.GP2346@one.firstfloor.org>
	 <1206170695.2438.39.camel@entropy>
	 <20080322091001.GA7264@one.firstfloor.org>
	 <a36005b50803232120j63fb08d8p4a6cfdc8df2a3f21@mail.gmail.com>
	 <1206335761.2438.63.camel@entropy>
	 <a36005b50803241242r2a9b38c5s57d9ac6b084021fa@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 24 Mar 2008 14:47:18 -0700
Message-Id: <1206395238.2438.68.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-24 at 12:42 -0700, Ulrich Drepper wrote:
> On Sun, Mar 23, 2008 at 10:16 PM, Nicholas Miell <nmiell@comcast.net> wrote:
> >  The limit is filesystem dependent -- I think ext2/3s is something like
> >  4k total for attribute names and values per inode.
> >
> >  That's more than enough space for the largest executable on my system
> >  (emacs at 36788160 bytes) which would have a 1123 byte predictive bitmap
> >  (plus space for the name e.g. "system.predictive_bitmap"). The bitmap
> >  also could be compressed.
> 
> 4k attribute means support for about 32768 pages.  That's a total of
> 134MB.  I think this qualifies as sufficient.  Also, I assume the
> attribute limit is just a "because nobody needed more so far" limit
> and could in theory be extended.

The on-disk format theoretically supports multi-block xattrs, but the
kernel driver is hardcoded to support only one.

Also, keep in mind that that 4k limit is for all attributes for an inode
and includes xattr names, values, and various bits of meta data. As
such, the limit is actually less than 4k total and the space is shared
among POSIX ACLs, SELinux contexts and whatever other attributes the
user would like to store on the file.

(Actually, it's 4k plus whatever xattr space there is in the inode,
which depends on how the filesystem was formatted.)

-- 
Nicholas Miell <nmiell@comcast.net>

