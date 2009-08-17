Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810AbZHQNxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbZHQNxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 09:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbZHQNxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 09:53:10 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:53270 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbZHQNxI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 09:53:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZIG7XEeqixU1Qb1nMFQr5OSGFJ+a4lqbriELgJV7M0qayOszxjD5bpJnJ4Dvl3QKJi
         1PFeH0trmaHgL07IrCiuirQf91I+fHmjgkG0zPsNHsAcaf2RV13uGEz0rtlVlzvbV0Sw
         Syquy5DzAr8rePmz3bdhdwi9kZjEoGKTWe3dc=
MIME-Version: 1.0
In-Reply-To: <1250514738.8475.26.camel@heimdal.trondhjem.org>
References: <6278d2220908161540h78f17424m592c5acf3420f906@mail.gmail.com>
	 <1250514738.8475.26.camel@heimdal.trondhjem.org>
Date: Mon, 17 Aug 2009 14:53:08 +0100
Message-ID: <6278d2220908170653s45df9989t9fa550f7efa0c182@mail.gmail.com>
Subject: Re: [2.6.31-rc5] oops: NFS4 client manager kthread...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-nfs@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trond,

On Mon, Aug 17, 2009 at 2:12 PM, Trond
Myklebust<Trond.Myklebust@netapp.com> wrote:
> On Sun, 2009-08-16 at 23:40 +0100, Daniel J Blueman wrote:
>> After losing and regaining ethernet link a few times with 2.6.31-rc5
>> [1], I've hit an oops in the NFS4 client manager kthread [2] on my
>> client with NFS4 homedir mount.
>>
>> Do you have a frequent test-case for when the client's manager kthread
>> gets invoked (with and without succeeding callbacks, due to eg a
>> firewall)? Server here is unpatched 2.6.30-rc6; I recall seeing
>> problems when the manager kthread gets invoked, across quite a few
>> kernel releases, just wasn't lucky enough to catch an oops.
>>
>> Oppsing in allow_signal() suggests task state corruption perhaps? I'm
>> downloading the debug kernel to match up the disassembly and line
>> numbers, if that helps? This time, the client had no firewall (but
>> have seen other issues when the callback has failed due to the
>> firewall).
>
> Those aren't Oopses. They are 'soft lockup' warnings. Basically, they're
> saying that the CPU is getting stuck waiting for a spin lock or a mutex.
>
> In this case, it is probably the fact that the state manager is going
> nuts trying to recover, while the connection to the server keeps coming
> up and going down.
>
> What does 'netstat -t' say when you get into this situation?

Whoops; it's true the stack-trace comes from the soft-lockup detector.

There was a single 200s link excursion, but the client didn't recover
as locks are held and never released it seems; I observe the
'192.168.1.250-m' NFS4 manager kthread being created and not going
away, despite IP connectivity with the server being fine after.

I'll reproduce it with stock 2.6.31-rc6 on the client and get 'netstat
-t' output.

Thanks for looking at this!
  Daniel

> Cheers
>  Trond
>
> --
> Trond Myklebust
> Linux NFS client maintainer
>
> NetApp
> Trond.Myklebust@netapp.com
> www.netapp.com
>



-- 
Daniel J Blueman
