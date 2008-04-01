Return-Path: <linux-kernel-owner+w=401wt.eu-S1757681AbYDAJPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681AbYDAJPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 05:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754968AbYDAJPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 05:15:23 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:52448 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124AbYDAJPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 05:15:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=n0cV5hCqsDg821sNuxFvliLctIaHsPd2fiZNWhlvQgNCHOebdriECmxxFXfazHcl5Rb7a5lJv0lcOPWd0NvU53UZmhLDkp91vtkAtaRK6HvyM58pptEFJYZ6ODpM/MD/ZxhZ1UtEJn1Juft36ApRADycniusMjd90suQMt/U5nU=
Message-ID: <84144f020804010215o209fbed8gf629dc6557fcd091@mail.gmail.com>
Date: Tue, 1 Apr 2008 12:15:21 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Artem Bityutskiy" <dedekind@yandex.ru>
Subject: Re: [RFC PATCH 26/26] UBIFS: include FS to compilation
Cc: "Artem Bityutskiy" <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Adrian Hunter" <ext-adrian.hunter@nokia.com>
In-Reply-To: <47F1F7A6.5020105@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
	 <1206629746-4298-27-git-send-email-Artem.Bityutskiy@nokia.com>
	 <84144f020804010039n47133bd3l63f02258a2670e72@mail.gmail.com>
	 <47F1F7A6.5020105@yandex.ru>
X-Google-Sender-Auth: 74f2d5158650b28e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

Pekka Enberg wrote:
> > But these don't make much sense to me. Why would you want to be able
> > to compile out printks at this granularity? Why not enable all of them
> > when CONFIG_UBIFS_FS_DEBUG is enabled?

On Tue, Apr 1, 2008 at 11:51 AM, Artem Bityutskiy <dedekind@yandex.ru> wrote:
>  Well, its just more convenient for us. If I know the bug is somewhere in
>  the journal, I enable the journal messages - less flooding. We may
>  lessen the amount, but it is still handy to have some classes of
>  prints separate.

Yeah, perhaps that's a sign that you're doing it wrong? You currently
have 430 separate debug printks sprinkled around in UBIFS. The way to
reduce that is to move as much logging as possible higher up the call
chain and dump as much information as you can there. That's what
ext2_error() does, for example. So I'm not opposed to a ubifs_error()
or ubifs_warning() even if that's used in a controlled fashion. The
way you do debugging checks now is totally ad hoc and IMHO not
acceptable to the mainline kernel.

And like I said, if you need _tracing_ you might want to look at
Ingo's ftrace or some other similar tracing infrastructure and use
that. The upside of it is that you can basically have it enabled at
run-time too.

Pekka Enberg wrote:
> > Why would you not want to enable all of these for development kernels?

On Tue, Apr 1, 2008 at 11:51 AM, Artem Bityutskiy <dedekind@yandex.ru> wrote:
>  Some of the checks are very heavy-weight. For example, the tree checking
>  functions scan the whole TNC/LPT B-tree, which means they read it from
>  flash, they check CRC, and they make sure the tree is consistent and
>  has sane data. They are very useful when hunting bugs, but they are too
>  slow to be always enabled.

So perhaps you could just separate those heavy-weight options and have
all others under CONFIG_UBIFS_DEBUG?

                        Pekka
