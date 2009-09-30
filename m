Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbZI3UKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbZI3UKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 16:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbZI3UKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 16:10:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:28762 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784AbZI3UKt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 16:10:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=x-authentication-warning:to:cc:subject:references:from:date
         :in-reply-to:message-id:lines:user-agent:mime-version:content-type
         :content-transfer-encoding;
        b=Q4lpkaH7gPX9oB0n7+HzI3da0/Sn6Ao1Ac5CvxaCrfCuFPjb7fAJB8um2jxJPRtaZG
         4w8VVKKf0ZhP30sk2gjuxvr4WTPeqViGgjoHYDiNF9aWmvjp1xKuhavKMgsHS7mBE+8M
         hMzJ16JJdAdjZH7HiZ1kR1DFyv17lMavzg0gg=
To: =?iso-8859-15?q?Alejandro_Riveira_Fern=E1ndez?= 
	<ariveira@gmail.com>
Cc: lsorense@csclub.uwaterloo.ca (Lennart Sorensen),
       Randy Dunlap <rdunlap@xenotime.net>, Andy <genanr@emsphone.com>,
       linux-kernel@vger.kernel.org, git@vger.kernel.org
Subject: Re: How can I download a git commit as a diff patch?
References: <20090930154410.GA31502@thumper2>
	<20090930085500.a5856301.rdunlap@xenotime.net>
	<20090930190014.GA22161@csclub.uwaterloo.ca>
	<20090930213809.71c2a8e8@varda>
From: Jakub Narebski <jnareb@gmail.com>
Date: Wed, 30 Sep 2009 13:10:51 -0700 (PDT)
In-Reply-To: <20090930213809.71c2a8e8@varda>
Message-ID: <m3tyyk9ost.fsf@localhost.localdomain>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alejandro Riveira Fernández    <ariveira@gmail.com> writes:

> El Wed, 30 Sep 2009 15:00:14 -0400
> 
>  CCing git@vger.kernel.org ??
> 
> lsorense@csclub.uwaterloo.ca (Lennart Sorensen) escribió:
> 
>> On Wed, Sep 30, 2009 at 08:55:00AM -0700, Randy Dunlap wrote:
>>> On Wed, 30 Sep 2009 10:44:10 -0500 Andy wrote:
>>> 
>>>> I just want to down a particular git commit as a patch, not a git commit or
>>>> anything.  Yes, I can see the diffs on the web, but unless I am missing
>>>> something all are in unless html formats for me.  And cut and past from the
>>>> web page does not help either because some lines get mangled.  Is there some
>>>> site, or git itself, that would allow be to get the git commit as a simple
>>>> patch?
>>> 
>>> Look at the commitdiff using the web interface, then click on "raw" near
>>> the upper left corner.

Or better yet, if given installation of gitweb supports it, on the
'patch' link just on the right of 'raw' view.  Such patch can be
applied better by git-am (but both should work for GNU patch or
git-apply).

>> 
>> Of course some git diff's are not in a format that patch will like as
>> far as I can tell.
>> 
>> For example commit 6cdee2f96a97f6da26bd3759c3f8823332fbb438 which has
>> stuff like:
>> diff --cc drivers/net/ixp2000/ixpdev.c
>> index 588b44d,92fb823..1272434
>> --- a/drivers/net/ixp2000/ixpdev.c
>> +++ b/drivers/net/ixp2000/ixpdev.c
>> @@@ -67,9 -68,9 +68,9 @@@ static int ixpdev_xmit(struct sk_buff *
>>         ip->tx_queue_entries++;
>>         if (ip->tx_queue_entries == TX_BUF_COUNT_PER_CHAN)
>>                 netif_stop_queue(dev);
>> -       local_irq_enable();
>> +       local_irq_restore(flags);
>> 
>>  -      return 0;
>>  +      return NETDEV_TX_OK;
>>   }
>> 
>> 
>> 
>> Ehm, what does that mean?  patch doesn't like it.
>> 
>> Do git merges cause weird diffs?

Yes, by default for merges the 'commitdiff' view (and the 'raw'
version, i.e. 'commitdiff_plain' view) shows **combined** diff of
changes brought by merge (see git-diff manpage for details on this
format).

For merge commit you have to choose which of parents you want to have
diff from.  Go to 'commit' view, there in the header would be two or
more parents.  Click on the 'diff' link beside chosen parent, check if
it is the diff you want to get, and then click on 'patch' (or 'raw')
link.

-- 
Jakub Narebski
Poland
ShadeHawk on #git
