Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbYKJAlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbYKJAlo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 19:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbYKJAle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 19:41:34 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:53395 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447AbYKJAld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 19:41:33 -0500
Date: Sun, 9 Nov 2008 18:41:31 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, takedakn@nttdata.co.jp,
       haradats@nttdata.co.jp
Subject: Re: [TOMOYO #12 (2.6.28-rc2-mm1) 06/11] Common functions for
	TOMOYOLinux.
Message-ID: <20081110004131.GA25021@us.ibm.com>
References: <20081104060847.086543472@nttdata.co.jp> <20081104060951.618445959@nttdata.co.jp> <20081105151221.d605226f.akpm@linux-foundation.org> <200811090138.GBG65138.FVOHOJOtMLQFFS@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811090138.GBG65138.FVOHOJOtMLQFFS@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@I-love.SAKURA.ne.jp):
> Hello.
> 
> Andrew Morton wrote:
> > > +static bool is_select_one(struct tmy_io_buffer *head, const char *data)
> > > +{
> > > +	unsigned int pid;
> > > +	struct domain_info *domain = NULL;
> > > +
> > > +	if (sscanf(data, "pid=%u", &pid) == 1) {
> > 
> > PIDs are no longer system-wide unique, and here we appear to be
> > implementing new userspace ABIs using PIDs.
> > 
> I'm not familiar with virtualized environment.
> 
> There are two PIDs, PID seen from inside virtualized environment and
> PID seen from outside virtualized environment. To clarify, let me call
> the former "PIDv" and the latter "PIDg".
> 
> PIDv is not system-wide unique. But PIDg is system-wide unique, aren't they?
> The PID received from outside virtualized environment is PIDg and they are
> system-wide unique, am I right?

You are doing find_task_by_vpid(), so you are not looking up a task by
global pid.

-serge
