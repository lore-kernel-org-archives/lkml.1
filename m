Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764Ab0ABPTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab0ABPTb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 10:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666Ab0ABPTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 10:19:30 -0500
Received: from dsl.unpythonic.net ([206.222.212.217]:44410 "EHLO
	unpythonic.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751492Ab0ABPTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 10:19:30 -0500
Date: Sat, 2 Jan 2010 09:19:28 -0600
From: Jeff Epler <jepler@unpythonic.net>
To: Kevin Qu <rofail@gmail.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: how to get right euid?
Message-ID: <20100102151928.GB401@unpythonic.net>
References: <78aa970c1001020516m3d2255fj38f02629e7d740c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78aa970c1001020516m3d2255fj38f02629e7d740c8@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 02, 2010 at 09:16:42PM +0800, Kevin Qu wrote:
> sudo echo "some thing" > /proc/my_file
> 
> It denied. (But it works when I su to superuser and do so.)
> 
> So I checked the current_euid(),
> but it returns 1000 (not 0),Why?

This may be due to a misunderstanding of how shell redirects work.
Probably current_euid() is returning exactly the right thing.

When you execute
    some command line > somefile
the shell opens somefile for writing and makes it be fd 1 (stdout) using
dup2.  Then it execs 'some' with the argument array being
['some', 'command', 'line'].

So consider your sudo:  The shell, running as user 1000, opens
'somefile' for writing, then execs 'sudo' which happens to be setuid
root.

Jeff
