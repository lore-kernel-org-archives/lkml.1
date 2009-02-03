Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbZBCBJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbZBCBJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 20:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbZBCBJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 20:09:49 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:32205 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752822AbZBCBJs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 20:09:48 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5i6e/jf4gIXnIcfsMIxq0OTCnrV2BbeZLHu0Ocb2Iqz0Kjih12KwnebGpqnrsoAkw7BeFwwiunUHQqZtb8b8AOWZ4JdEy4DL0jQrPH3BbApNiX6RtEVsd+fDG/+ZkFKP5OHDxkOMZHoUWtjGaAu48/K/gKpwFod78QeJGreypuY=  ;
X-YMail-OSG: BU3PEUAVM1k1qDpB4IusrO7GII1itcNXZN9dv.G44MWjoSQAKJ9CtCRGmQYbeLeA_z4msO4vdEg27jSY1qfmybCG9l4XKhgYGstwlrtq42C.t1BKFWRPh2WEh4083IcML6ZEJOwjMu2MQ5VZ2IdxGTCO4XopT2W.Nd8IUPosQzIDdPUbTlhcD_jBPpPj9toaWW_IbLtgwf7AQkFP3tCDhH6.UnmNwwWeM7Hl6I0-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Federico Cuello <fedux@lugmen.org.ar>
Subject: Re: sync-Regression in 2.6.28.2?
Date: Tue, 3 Feb 2009 12:09:11 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org, Udo Wolter <Udo.Wolter@charite.de>,
       cf@charite.de
References: <20090127093533.GB7037@charite.de> <497F77F6.40905@lugmen.org.ar>
In-Reply-To: <497F77F6.40905@lugmen.org.ar>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902031209.12615.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 January 2009 08:09:10 Federico Cuello wrote:
> Ralf Hildebrandt escribió:
> > I recently installed 2.6.28.2 on our postfix/dovecot-based
> > mailboxserver. Previously, 2.6.28 and 2.6.28.1 have been running there
> > without a hitch.
> >
> > Now with 2.6.28.2 I had two major lockups: All writes to the users'
> > Maildirs (on ext4) would stall, the load would rise, "sync" would never
> > return.
> >
> > I had to "reboot -f -n" to get the machine back. All hanging processes
> > were unkillable, even with kill -9.
> > [...]
>
> The same is happening to me, but I have some logs taken with sysrq.
>
> Here is my vmstat output:
>
> procs -----------memory---------- ---swap-- -----io---- -system--
> ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
> id wa
>  0  2  99028  46536  26356 1569400    0    0     0     0 1400  437  0
> 3  0 96
>  0  2  99028  46536  26356 1569400    0    0     0     0 1344  355  0
> 6  0 94
>  0  2  99028  46536  26356 1569400    0    0     0     0 1373  387  0
> 0  0 100
>  0  2  99028  46536  26364 1569400    0    0     0    12 1403  384  1
> 0  0 99
>  0  2  99028  46536  26364 1569400    0    0     0     0 1370  378  0
> 0  0 100
>  0  2  99028  46536  26364 1569400    0    0     0     0 1351  346  0
> 0  0 100
>  0  2  99028  46536  26364 1569400    0    0     0     0 1395  412  0
> 0  0 100
>  0  2  99028  46536  26364 1569400    0    0     0     0 1349  332  0
> 0  0 100
>  0  2  99028  46536  26368 1569400    0    0     4     0 1407  387  0
> 0  0 100
>
> Notice the 100% iowait.
>
> I also managed to reproduce it doing a rsync from one partition to a USB
> drive. After the lockup I can't read any file from the source partition,
> but the other partitions can be accessed normally.

Hm, thanks for reporting, can you guys get a sysrq+W trace when the system
reaches this state?

Thanks,
Nick
