Return-Path: <linux-kernel-owner+w=401wt.eu-S1758215AbZDPXuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbZDPXuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 19:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756633AbZDPXuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 19:50:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51568 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780AbZDPXuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 19:50:04 -0400
Date: Fri, 17 Apr 2009 00:49:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH -tip] remove the BKL: Replace BKL in mount/umount
	syscalls with a mutex
Message-ID: <20090416234957.GE26366@ZenIV.linux.org.uk>
References: <1239892078-6039-1-git-send-email-abogani@texware.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239892078-6039-1-git-send-email-abogani@texware.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 04:27:58PM +0200, Alessio Igor Bogani wrote:
> Replace ths BKL in sys_mount()/sys_umount() syscalls with a regular mutex.

NAK.  Push BKL into instances if you care and deal with those one by one.
New and unwarranted system-wide exclusion around hell knows what code
(we *are* talking about the stuff that is very likely to do at least some
IO, dependent on fs internals, phase of moon and amount of farting gnats
in the vicinity) is right out.
