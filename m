Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbYCMGUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbYCMGUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 02:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbYCMGTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 02:19:53 -0400
Received: from hu-out-0506.google.com ([72.14.214.234]:37743 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbYCMGTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 02:19:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=Oc+gB3INlEJsPRmR+ZuqKZhUF4mlA778YJkQ9zZP3tjY4jXwS2F2HLadiRm7urTBh2GVfnHcTakn1hNeoZMU7/UzmHVHsDlLQuja1lBsn9LhZZb6RMydqAyPGZFq2DeD7jF4+Pwy2Z7P3MRK4hdjXeoq3c+kEz0htleAl9iS3rk=
Date: Thu, 13 Mar 2008 07:19:37 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 4/4] ide-tape: remove pipeline-specific code from
	idetape_add_chrdev_read_request()
Message-ID: <20080313061937.GG4266@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1205082632-3418-1-git-send-email-petkovbb@gmail.com> <200803110025.51072.bzolnier@gmail.com> <20080312055803.GD4266@gollum.tnic> <200803121451.23925.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803121451.23925.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 02:51:23PM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Wednesday 12 March 2008, Borislav Petkov wrote:
> 
> [...]
> 
> > > > the read request's buffer directly thru idetape_queue_rw_tail()
> > > > 
> > > > 3. Do next request buffer allocation (tape->merge_stage)
> > > 
> > > Isn't idetape_init_read() taking care of 3.?
> > 
> > i wanted to have the whole handling at one place and let _init_read() only
> > prepare the read. Now we don't allocate any new tape->merge_stage anymore,
> > which is wrong. Originally, this happened in _init_read(), however, if we do
> > idetape_queue_rw_tail(), we should alloc the new stage _after_ queueing the
> 
> The original driver doesn't do this - it just calls idetape_queue_rw_tail(),
> could it be a bug in the original driver?

Damn, i see it now, idetape_queue_rw_tail() queues the request and then simply
_reuses_ the tape->merge_stage buffer by doing

        if (tape->merge_stage)
		idetape_init_merge_stage(tape);

so no need for reallocation. Whew! :)

-- 
Regards/Gruﬂ,
    Boris.
