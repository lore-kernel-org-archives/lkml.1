Return-Path: <linux-kernel-owner+w=401wt.eu-S1763470AbXLTRck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763470AbXLTRck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 12:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbXLTRcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 12:32:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48873 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751254AbXLTRca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 12:32:30 -0500
Date: Thu, 20 Dec 2007 09:32:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <clameter@sgi.com>,
       Pavel Machek <pavel@suse.cz>, linux-pm@lists.linux-foundation.org
Subject: Re: OOPS: 2.6.24-rc5-mm1 -- EIP is at r_show+0x2a/0x70  -- 
 (triggered by "cat /proc/iomem" AFTER suspend-to-disk/resume)
Message-Id: <20071220093206.22f319b0.akpm@linux-foundation.org>
In-Reply-To: <476A703B.50804@gmail.com>
References: <a44ae5cd0712192040k7480682eoa29f33d70a91c618@mail.gmail.com>
	<4769F409.6030300@gmail.com>
	<4769FF37.5060308@gmail.com>
	<476A703B.50804@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 08:38:03 -0500 Miles Lane <miles.lane@gmail.com> wrote:

> On further investigation, "cat /proc/iomem" does not trigger the stack 
> trace until after a suspend-to-disk/resume cycle has occurred.

I still can't reproduce this.

Could you please try this?

- cat /proc/iomem
- suspend/resume
- do

while read i
do
echo $i
sleep 1
done < /proc/iomem

then, with luck, we'll be able to work out which /proc/iomem record
immediately precedes the corrupted one.
