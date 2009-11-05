Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbZKEQgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbZKEQgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 11:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756761AbZKEQgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 11:36:00 -0500
Received: from smtp5.netcologne.de ([194.8.194.25]:37424 "EHLO
	smtp5.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbZKEQf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 11:35:59 -0500
Date: Thu, 5 Nov 2009 17:36:03 +0100
From: Max Kellermann <max@duempel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, mk@cm4all.com
Subject: Re: [PATCH] pipe: don't block after data has been written
Message-ID: <20091105163603.GA4089@squirrel.roonstrasse.net>
Mail-Followup-To: Eric Dumazet <eric.dumazet@gmail.com>,
	linux-kernel@vger.kernel.org, mk@cm4all.com
References: <20091105153147.27473.19570.stgit@woodpecker.roonstrasse.net> <4AF2FD04.4030306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF2FD04.4030306@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009/11/05 17:27, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Your patch breaks many programs, that dont use poll()/select()
> 
> char result[1000000];
> main()
> {
> 	computethings();
> 	write(1, buffer, 1000000);
> }

Your code does not check the return value of write().  This is a bug.

So how exactly does my patch break this program?

Let's read some more of the manual you cited: "If a write() requests
that more bytes be written than there is room for (for example, the
process' file size limit or the physical end of a medium), only as
many bytes as there is room for shall be written."
