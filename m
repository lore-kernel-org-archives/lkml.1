Return-Path: <linux-kernel-owner+w=401wt.eu-S1767028AbXDSUcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767028AbXDSUcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 16:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767029AbXDSUcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 16:32:05 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767028AbXDSUcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 16:32:03 -0400
Date: Thu, 19 Apr 2007 13:30:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org,
       kvm-devel@lists.sourceforge.net
Subject: Re: [GIT PULL] kvm oops fix
In-Reply-To: <4627BE6B.8030006@garzik.org>
Message-ID: <alpine.LFD.0.98.0704191325000.9964@woody.linux-foundation.org>
References: <1176997839110-git-send-email-avi@qumranet.com>
 <alpine.LFD.0.98.0704190949580.9964@woody.linux-foundation.org>
 <4627BE6B.8030006@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Apr 2007, Jeff Garzik wrote:
> 
> What is the easiest way to completely undo a pull, reverting the branch to the
> HEAD present before the pull?

You can either do

	git reset --hard ORIG_HEAD

(git will set ORIG_HEAD before things like pulls or resets, so you can 
always go back), or, if you have reflogs enabled (and if you set up your 
repository with a modern git version it probably will be enabled by 
default), you can just do

	git reset --hard @{1}

where "@{1}" just means "HEAD ref state one change ago" (the same way you 
can say "@{2.hours.ago}" to mean HEAD state two hours ago).

In either case, double-check that that is indeed the version you want to 
revert to with

	git log ORIG_HEAD
 or
	git log @{1}

first, since obviously if you give "git reset --hard" the wrong version, 
it will reset to the wrong state. Although especially with reflogs, your 
previous state will always be logged, so you can always re-do what you 
undid by (again) doing "git reset --hard @{1}" to get back the previous 
state ;)

ALSO! Make sure that you don't have any dirty state in your working tree 
that you don't want to lose! "git reset --hard" will do what it implies: 
it will reset your tree. Very much including throwing away all your dirty 
state (and that you can't get back by going to a previous commit, since 
it was never committed!)

			Linus
