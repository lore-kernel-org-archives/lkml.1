Return-Path: <linux-kernel-owner+w=401wt.eu-S1759552AbZLOJsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552AbZLOJsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 04:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759540AbZLOJsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 04:48:42 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33305 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759444AbZLOJsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 04:48:41 -0500
To: Kay Sievers <kay.sievers@vrfy.org>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       greg@kroah.com
In-reply-to: <ac3eb2510912120207r528229f6uf8bd0535a6ce76a@mail.gmail.com>
	(message from Kay Sievers on Sat, 12 Dec 2009 11:07:54 +0100)
Subject: Re: get_sb_single() - do not pass options twice
References: <1257460103.2126.0.camel@yio.site> <ac3eb2510912120207r528229f6uf8bd0535a6ce76a@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1NKU1C-0005jr-P8@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 15 Dec 2009 10:48:34 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Dec 2009, Kay Sievers wrote:
> Ping! Can someone please have a look and comment on that?
> Something like this will now be needed for 2.6.33 to silent a warning.
> 
> Thanks,
> Kay
> 
> > Cc: Greg KH <greg@kroah.com>
> > Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> > ---
> >  fs/super.c |    2 ++
> >  1 file changed, 2 insertions(+)
> >
> > --- a/fs/super.c
> > +++ b/fs/super.c
> > @@ -900,6 +900,8 @@ int get_sb_single(struct file_system_typ
> >                        deactivate_locked_super(s);
> >                        return error;
> >                }
> > +               /* options usually get mangled and can only be parsed once */
> > +               data = NULL;
> >                s->s_flags |= MS_ACTIVE;
> >        }
> >        do_remount_sb(s, flags, data, 0);

I think the do_remount_sb() is a NOP in that case.  So shouldn't it
rather be

	} else {
		do_remount_sb(s, flags, data, 0);
	}

?

Thanks,
Miklos
