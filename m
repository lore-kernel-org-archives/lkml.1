Return-Path: <linux-kernel-owner+w=401wt.eu-S1760455AbYBZHnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760455AbYBZHnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 02:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbYBZHng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 02:43:36 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755621AbYBZHnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 02:43:35 -0500
Date: Mon, 25 Feb 2008 23:43:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Chris Wedgwood <cw@f00f.org>
Subject: Re: Proposal for "proper" durable fsync() and fdatasync()
Message-Id: <20080225234319.f4589ae4.akpm@linux-foundation.org>
In-Reply-To: <20080226072649.GB30238@shareable.org>
References: <20080226072649.GB30238@shareable.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 07:26:50 +0000 Jamie Lokier <jamie@shareable.org> wrote:

> (It would be nicer if sync_file_range()
> took a vector of ranges for better elevator scheduling, but let's
> ignore that :-)

Two passes:

Pass 1: shove each of the segments into the queue with
        SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE

Pass 2: wait for them all to complete and return accumulated result
        with SYNC_FILE_RANGE_WAIT_AFTER


