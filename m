Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbZAEM0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbZAEM0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 07:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbZAEM00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 07:26:26 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35940 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939AbZAEM00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 07:26:26 -0500
Date: Mon, 5 Jan 2009 13:24:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, ebiederm@xmission.com,
       bastian@waldi.eu.org, daniel@hozac.com, xemul@openvz.org,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 5/7][v4] Protect cinit from blocked fatal signals
Message-ID: <20090105122423.GA3313@redhat.com>
References: <20081224114414.GA7879@us.ibm.com> <20081224115229.GE8020@us.ibm.com> <20081224160931.GC11593@redhat.com> <20081231000445.CEBC8FC278@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081231000445.CEBC8FC278@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30, Roland McGrath wrote:
>
> > > + * If @signal refers to a container-init and @signr is neither SIGKILL nor
> > > + * SIGSTOP, it was queued because it was blocked when it was posted.
> >
> > This is not right too. It is possible that init had a handler when
> > the signal was sent, and the handler was set to SIG_DFL before the
> > signal was dequeued.
>
> do_sigaction's sig_handler_ignored() should exclude that.

Yes sure, but sig_handler_ignored(sig) can be false, it doesn't take
SIGNAL_UNKILLABLE into account.

Oleg.

