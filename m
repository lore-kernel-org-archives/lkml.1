Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816AbXIHKPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbXIHKPb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 06:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbXIHKPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 06:15:24 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:29924 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752078AbXIHKPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 06:15:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Xg65q8BsFZBTcBZm4byazI0UMxixJa66T9xZClzFrnCGFy9ZJYAUdvB944CEVWfySwJx39WrgDLMfW1EfcbIOZWFPnO27jU1R4KKPZFX/lexYDBbT+j/noEPhsGU7QlZ143aQpC2eT0b0Wm6LRwg2TKUseVDjUHApAxgYGqZK9Y=  ;
X-YMail-OSG: wVP9S3IVM1ndAE6bPGvkPfMRPO6ZTsEX6nYiSuj6zV2cNo69L_hnQPHt_gYF.i3Sr16wCEX80Q--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: patch: improve generic_file_buffered_write() (2nd try 1/2)
Date: Sat, 8 Sep 2007 06:12:52 +1000
User-Agent: KMail/1.9.5
Cc: Bernd Schubert <bs@q-leap.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
       brian@clusterfs.com
References: <200709051546.06224.bs@q-leap.de> <200709081731.51263.nickpiggin@yahoo.com.au> <874pi5cx20.fsf@informatik.uni-tuebingen.de>
In-Reply-To: <874pi5cx20.fsf@informatik.uni-tuebingen.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709080612.52749.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 September 2007 19:43, Goswin von Brederlow wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> writes:
> > Lustre should probably have to be ported over to write_begin/write_end in
> > order to use it too. With the patches in -mm, if a filesystem is still
> > using prepare_write/commit_write, the vm reverts to a safe path which
> > avoids the deadlock (and allows multi-seg io copies), but copies the data
> > twice.
>
> Not quite relevant for the performance problem. The situation is like
> this:
>
> lustre servers  <-lustre network protocol-> lustre client <-NFS-> desktop
>
> The NFSd problem is on the lustre client that only plays gateway. That
> is not to say that the lustre servers or desktop loose performance due
> to fragmenting writes too but it isn't that noticeable there.

OK, but the filesystem client would need to support write_begin/write_end
in order for writes to do multi-seg iovecs. nfsd of course will also be fixed
by the earlier patch I referenced, but you did want userspace multi-seg
writes to work too...


> > OTOH, this is very likely to go upstream, so your filesystem will need to
> > be ported over sooner or later anyway.
>
> Lustre copies the ext3 source from the kernel, patches in some extra
> features and renames them during build. So one the one hand it always
> breaks whenever someone meddles with the ext3 code. On the other hand
> improvement for ext3 get picked up by lustre semi automatically.
>
> In this case lustre would get the begin_write() function from ext3 and
> use it.

OK. Yes ext3 is converted in -mm.
