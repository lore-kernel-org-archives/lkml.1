Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbZIVGXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbZIVGXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 02:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155AbZIVGXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 02:23:09 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:43123 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbZIVGXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 02:23:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=P5EbRdTLbjbwct7l7wDGfUUOBgmZa0Q4oJdJz8VBzetXHN4/NKQoG9IVkr+UgMNib8
         WJC9OEwApO2YbsdHeTJI9v5tHmVrD8lljuqpLUG0g1QUNdUfHIs4OaCX1OXYv3jS0/CQ
         iAsiCXO+16O6erWFnyqFKqk6iiaZBED+H1WPY=
MIME-Version: 1.0
Date: Tue, 22 Sep 2009 12:23:11 +0600
Message-ID: <b8f627e0909212323mbeb0fd1yba25aafb58ef686b@mail.gmail.com>
Subject: splice between non-pipe (tcp socket) fds
From: =?KOI8-R?B?7cHSyyDrz9LFzsLF0sc=?= <socketpair@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I want splice() to work with two tcp sockets().I think to implement
this. Two questions:

1. Is any work in this direction?
2. Why this functionality does not implemented now? any difficulties?

I think API should consist of 2 main functions:
1. detach available buffers from fd1 (and save info in some struct)
2. attach buffers to fd2 (from this struct)
this functions should be called under some lock to guarantee
atomicity. if something happen, return buffers back to original file.

I mean, that, for example, skb_splice_bits should not splice into
pipe..... it should splice skb into list of kernel buffers independent
from the "type" of fd (socket, file, and so on...)


At now, I think that the most quick way to acheive my results,  is to
create intermediate temporary pipe inside kernel and splice from
non-pipe fd to pipe, and than from pipe to second non-pipe fd.

Is this method appropriate, as you think ?
