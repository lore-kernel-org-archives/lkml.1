Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbZF1NjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbZF1NjH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 09:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756431AbZF1Niy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 09:38:54 -0400
Received: from mail.open.by ([193.232.92.17]:54049 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756611AbZF1Niw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 09:38:52 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 8851 [Jun 28 2009]
X-SpamTest-Info: helo_type=3
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Sun, 28 Jun 2009 16:40:15 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kobject_set_name_vargs memory leak
Message-ID: <20090628134015.GA3349@localdomain.by>
References: <20090626143652.GB6281@localdomain.by>
 <20090626144949.GA24173@suse.de>
 <20090626232339.GD3858@localdomain.by>
 <m18wjeqven.fsf@fess.ebiederm.org>
 <20090627093932.GB3342@localdomain.by>
 <1246147018.24693.97.camel@yio.site>
 <m17hyw1s0h.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17hyw1s0h.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/28/09 05:07), Eric W. Biederman wrote:
> Date: Sun, 28 Jun 2009 05:07:10 -0700
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> To: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
> 	Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] kobject_set_name_vargs memory leak
> User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
> 
> Kay Sievers <kay.sievers@vrfy.org> writes:
> 
> > On Sat, 2009-06-27 at 12:39 +0300, Sergey Senozhatsky wrote:
> >
> >> > >> Or something along those lines, I can't remember the exact reasoning
> >> > >> this early in the morning.
> >> > >> 
> >> > >> Kay, do you remember?
> > [....]
> > Hmm, yes, I think there was only something to work around during the
> > transition from the static name array, which is gone now. At least I
> > can't see anything we need to care about with the current code.
> >
> > I guess, that would leak an allocated name, when it is set several times
> > in a row? Something like this?
> 
> But setting a kobject's name several times in a row is a bug.  You
> need to call kobject_rename if you are going to change the name.
> 
Yes.

> So how about we fix the driver core not to do that.  Stop treating fmt
> as a flag, and make it clear kobject_add should not be passed a name.
> 
Sounds good.

	Sergey
