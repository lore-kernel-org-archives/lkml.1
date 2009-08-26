Return-Path: <linux-kernel-owner+w=401wt.eu-S1756370AbZHZJPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbZHZJPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 05:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755073AbZHZJPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 05:15:12 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:38658 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbZHZJPL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 05:15:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lrVGT3eNaYF9BpjPvC10oDXwslncg4bowSlwLqLNKxRcuZzwrGohU2wXfEQo+84DNL
         gxCvg6i++zp3cyuIK/DKN7dIXFJbdbt40jxaFiuIoKxGH7CCoZwnjw1yl5DoctzQDRWz
         LHp/P/uW2smcBFcbadfiQ8aSidb0kqRtv3dmo=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0908251823470.18518@makko.or.mcafeemobile.com>
References: <8a1bd2320908251748u324ae5e6g7015069180253db3@mail.gmail.com>
	 <alpine.DEB.2.00.0908251812450.18518@makko.or.mcafeemobile.com>
	 <alpine.DEB.2.00.0908251823470.18518@makko.or.mcafeemobile.com>
Date: Wed, 26 Aug 2009 11:15:10 +0200
Message-ID: <8a1bd2320908260215w23d1f426x33f90e38ccc3fe2c@mail.gmail.com>
Subject: Re: PROBLEM: Epoll frequently fails to notify connects at connect 
	bursts
From: Will Brown <dr.hfuhruhurr@gmail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 3:24 AM, Davide Libenzi<davidel@xmailserver.org> wrote:
> On Tue, 25 Aug 2009, Davide Libenzi wrote:
>
>> Multiple quasi-simultaneous events for the same fd are merged. This is why
>> on POLLIN on accepting sockets you want to do something like:
>>
>>       while ((afd = accept(sfd, ...)) != -1)
>>               add_client(afd);
>
> Of course, with  sfd  in non-blocking mode. Alternatively, you drop EPOLLET
> for the  sfd  socket.
>

Aha! Thank you immensely Davide. It cost me one week of frustration already.

1. Where should I have picked up this gem of essential information? I
haven't seen it in the man-pages for either 'epoll' or 'accept'.

2. Is it better to use a level-triggered listener socket, or to use
the accept-loop?

Thanks a million,
Will
