Return-Path: <linux-kernel-owner+w=401wt.eu-S1751703AbZH0Rgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbZH0Rgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbZH0Rga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:36:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57860 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbZH0Rga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:36:30 -0400
Date: Thu, 27 Aug 2009 13:36:31 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <gregory.haskins@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: FTRACE: regression in 31-rc7
In-Reply-To: <4A96BD50.9040204@gmail.com>
Message-ID: <alpine.DEB.2.00.0908271334230.19345@gandalf.stny.rr.com>
References: <4A96B55C.10001@gmail.com> <20090827164007.GA30679@elte.hu> <4A96BB40.1070306@gmail.com> <alpine.DEB.2.00.0908271301200.29943@gandalf.stny.rr.com> <4A96BD50.9040204@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 27 Aug 2009, Gregory Haskins wrote:

> Hi Steve,
> 
> Steven Rostedt wrote:
> instrumented for some reason.
> > 
> > Hmm, so you think something with the modules broke? I can test that out 
> > here.
> 
> Thats my (admittedly fairly ignorant) theory based on the limited data
> samples I have in front of me. :)
> 
> If I get a chance later, I will try to do something more scientific, or
> at least a bisect.

I just did this:

 # uname -r
2.6.31-rc7
 # echo :mod:ext3 > set_ftrace_filter
 # echo function_graph > current_tracer
 # cat trace
# tracer: function_graph
#
# CPU  DURATION                  FUNCTION CALLS
# |     |   |                     |   |   |   |
 1)   6.928 us    |  ext3_permission();
 1)   1.234 us    |  ext3_permission();
 ------------------------------------------
 1)  gdm-bin-3477  =>   pcscd-2951  
 ------------------------------------------

 1)   1.306 us    |  ext3_permission();
 1)   1.314 us    |  ext3_permission();
 1)   1.244 us    |  ext3_permission();
 1)   1.364 us    |  ext3_permission();
 1)   1.251 us    |  ext3_permission();
 1)   1.473 us    |  ext3_permission();
 1)   1.306 us    |  ext3_permission();
 1)   1.401 us    |  ext3_permission();
 1)   1.243 us    |  ext3_permission();
 1)   1.301 us    |  ext3_permission();
 1)   1.439 us    |  ext3_permission();
 1)   1.239 us    |  ext3_permission();
 1)   1.331 us    |  ext3_permission();
 1)   1.423 us    |  ext3_permission();
 1)   1.243 us    |  ext3_permission();
 1)   1.321 us    |  ext3_permission();
 ------------------------------------------
 1)   pcscd-2951   =>  gdm-bin-3477 
 ------------------------------------------

 1)   2.567 us    |  ext3_permission();
 1)   1.139 us    |  ext3_permission();
 1)   2.329 us    |  ext3_permission();
 1)   1.246 us    |  ext3_permission();
 1)   1.321 us    |  ext3_permission();
 1)   0.989 us    |  ext3_permission();
 1)   1.261 us    |  ext3_permission();
 1)   1.209 us    |  ext3_permission();
 1)   1.221 us    |  ext3_permission();
 1)   0.968 us    |  ext3_permission();
 1)   2.319 us    |  ext3_permission();
 1)   1.221 us    |  ext3_permission();
 1)   2.199 us    |  ext3_permission();
 1)   1.269 us    |  ext3_permission();
 ------------------------------------------
 1)  gdm-bin-3477  =>   bash-3198   
 ------------------------------------------

 1)   2.852 us    |  ext3_permission();
 1)               |  ext3_readdir() {
 1)   1.249 us    |    free_rb_tree_fname();
 1)               |    ext3_htree_fill_tree() {
 1)               |      htree_dirblock_to_tree() {
 1)               |        ext3_bread() {
 1)               |          ext3_getblk() {
 1)               |            ext3_get_blocks_handle() {
 1)   1.046 us    |              ext3_block_to_path();


This is with the latest Linus git:

commit 1e23502cc57cef33455ac7cb9111e3c6d991a894
Merge: e99b1f2... 3161e45...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Aug 26 20:54:48 2009 -0700

-- Steve

