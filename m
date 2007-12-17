Return-Path: <linux-kernel-owner+w=401wt.eu-S1761518AbXLQFF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761518AbXLQFF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 00:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbXLQFFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 00:05:22 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48052 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbXLQFFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 00:05:21 -0500
Date: Mon, 17 Dec 2007 05:05:12 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: div64: Rework 64-bit type safety checks in do_div().
Message-ID: <20071217050512.GY8181@ftp.linux.org.uk>
References: <20071217014805.GA15156@linux-sh.org> <20071216190418.8acc64d1.akpm@linux-foundation.org> <20071217032019.GA15449@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071217032019.GA15449@linux-sh.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2007 at 12:20:19PM +0900, Paul Mundt wrote:
> (Adding Ingo to CC regarding kernel/lockdep_proc.c..)
 
> That seems to be an accurate asessment, yes. If do_div(s64, ...) is buggy
> behaviour, then the current check is fine, and the callsites should be
> corrected. Though if there's code in-tree that relies on s64 do_div, that seems
> to be a more problematic issue.

It is a bug and the only existing callers that manage to work are those that
make sure that signed value is positive.  Still asking for trouble...
