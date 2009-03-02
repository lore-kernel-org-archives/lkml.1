Return-Path: <linux-kernel-owner+w=401wt.eu-S1757858AbZCBR6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbZCBR6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 12:58:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbZCBR6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 12:58:37 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:55500 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbZCBR6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 12:58:36 -0500
Subject: Re: [RFC][PATCH 8/8] check files for checkpointability
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Nathan Lynch <ntl@pobox.com>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       hch@infradead.org, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20090302174433.GA12708@us.ibm.com>
References: <20090227203425.F3B51176@kernel>
	 <20090227203435.98735E54@kernel> <20090302133754.GA8033@us.ibm.com>
	 <20090302095917.6cfeda55@thinkcentre.lan>
	 <1236011251.26788.450.camel@nimitz>
	 <20090302112247.76bb3662@thinkcentre.lan>
	 <1236015052.26788.471.camel@nimitz>  <20090302174433.GA12708@us.ibm.com>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 09:58:26 -0800
Message-Id: <1236016706.26788.478.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 11:44 -0600, Serge E. Hallyn wrote:
> Which is what we actually do, right?
> 
> Actually we have userspace create the tasks first, and
> then each task calls sys_restart which does restore_files().

Quoting:

http://git.ncl.cs.columbia.edu/?p=linux-cr.git;a=commitdiff;h=3c1b1900f92ed12f5020a7b566065bffda2908d8;hp=7aec1a8f3345bb33c3f93226c895a45ec269bb59

> Restarting of multiple processes expects all restarting tasks to call
> sys_restart(). Once inside the system call, each task will restart
> itself at the same order that they were saved. The internals of the
> syscall will take care of in-kernel synchronization bewteen tasks.

I guess it is OK since everybody sleeps once they enter sys_restart()
until the container init decides it is ready to go.  

-- Dave

