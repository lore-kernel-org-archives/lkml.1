Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbYLBWNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbYLBWNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 17:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYLBWNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 17:13:17 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40265 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbYLBWNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 17:13:16 -0500
Date: Tue, 2 Dec 2008 14:12:45 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Bastian Blank <bastian@waldi.eu.org>, oleg@redhat.com,
       ebiederm@xmission.com, roland@redhat.com, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, xemul@openvz.org
Subject: Re: [RFC][PATCH 1/5] pid: Implement ns_of_pid
Message-ID: <20081202221244.GA991@us.ibm.com>
References: <20081126034242.GA23120@us.ibm.com> <20081126034442.GA23238@us.ibm.com> <20081127011910.GD13545@wavehammer.waldi.eu.org> <20081201202422.GD12493@us.ibm.com> <20081202115841.GC1132@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202115841.GC1132@wavehammer.waldi.eu.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bastian Blank [bastian@waldi.eu.org] wrote:
| On Mon, Dec 01, 2008 at 12:24:22PM -0800, Sukadev Bhattiprolu wrote:
| > Bastian Blank [bastian@waldi.eu.org] wrote:
| > | On Tue, Nov 25, 2008 at 07:44:42PM -0800, Sukadev Bhattiprolu wrote:
| > | > +/* ns_of_pid returns the pid namespace in which the specified
| > | > + * pid was allocated.
| > | > + */
| > | > +static inline struct pid_namespace *ns_of_pid(struct pid *pid)
| > | > +{
| > | > +	struct pid_namespace *ns = NULL;
| > | > +	if (pid)
| > | > +		ns = pid->numbers[pid->level].ns;
| > | > +	return ns;
| > | > +}
| > | > +
| > | When can the pid argument be null?
| > Soon after creation but more importantly, after detach_pid()
| > (release_task).
| 
| pid is a function argument and the function does not call detach_pid. So
| please try again.

ns_of_pid() like pid_nr(), pid_nr_ns(), pid_task() etc is a low level helper
unction. ns_of_pid(), like the other helpers can potentially be called for a
process that has already called detach_pid() (i.e for a task that is exiting
but not yet waited on).  Hence the 'if (pid)' in ns_of_pid().

Sukadev
