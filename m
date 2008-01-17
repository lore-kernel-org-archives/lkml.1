Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbYAQDbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbYAQDbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 22:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYAQDbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 22:31:25 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:53857 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752668AbYAQDbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 22:31:24 -0500
Message-ID: <400540692.29046@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Thu, 17 Jan 2008 11:31:25 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] Converting writeback linked lists to a tree based data structure
References: <20080115080921.70E3810653@localhost> <1200386774.15103.20.camel@twins> <532480950801150953g5a25f041ge1ad4eeb1b9bc04b@mail.gmail.com> <400452490.28636@ustc.edu.cn> <532480950801161055u4191ef1ak644dd4528ab60f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532480950801161055u4191ef1ak644dd4528ab60f8@mail.gmail.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JFLTR-0002pn-4Y@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 10:55:28AM -0800, Michael Rubin wrote:
> On Jan 15, 2008 7:01 PM, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> > Basically I think rbtree is an overkill to do time based ordering.
> > Sorry, Michael. But s_dirty would be enough for that. Plus, s_more_io
> > provides fair queuing between small/large files, and s_more_io_wait
> > provides waiting mechanism for blocked inodes.
> 
> I think the flush_tree (which is a little more than just an rbtree)
> provides the same queuing mechanisms that the three or four lists
> heads do and manages to do it in one structure. The i_flushed_when
> provides the ability to have blocked inodes wait their turn so to
> speak.
> 
> Another motivation behind the rbtree patch is to unify the data
> structure that handles the priority and mechanism of how we write out
> the pages of the inodes. There are some ideas about introducing
> priority schemes for QOS and such in the future. I am not saying this
> patch is about making that happen, but the idea is to if possible
> unify the four stages of lists into a single structure to facilitate
> efforts like that.

Yeah, rbtree is better than list_heads after all. Let's make it happen.

