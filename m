Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569AbZBAGud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbZBAGud (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 01:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbZBAGuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 01:50:25 -0500
Received: from 1wt.eu ([62.212.114.60]:1943 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbZBAGuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 01:50:24 -0500
Date: Sun, 1 Feb 2009 07:50:20 +0100
From: Willy Tarreau <w@1wt.eu>
To: Angelo Borsotti <angelo.borsotti@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: processes/threads monitor
Message-ID: <20090201065020.GN5038@1wt.eu>
References: <541298b90901311357o593a4339t46a44e8933bb1a6b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541298b90901311357o593a4339t46a44e8933bb1a6b@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 31, 2009 at 10:57:36PM +0100, Angelo Borsotti wrote:
(...)
> A much more efficient solution would be for the process monitor to be
> allowed to wait
> for the termination of any processes/threads belonging to a specified list.
> Note that this would mean waiting for one among several events to occur.
> 
> Are there any solution to this?

This is called a launcher or wrapper. Your process just has to fork/exec
the process to monitor, and it receives a sigchild when that one dies.
One well-known process does that all the time, it's called init :-)

But this does not save you from checking that your processes are properly
working. A process which just dies is the trivial case. Most unhandled
errors are from stuck processes, which need to be killed and respawned.
So if you have to check that a process is working correctly and you can
kill it, it's often easy to restart it, and you don't need your wrapper.

You're back to the script you found inefficient ;-)

Cheers,
Willy

