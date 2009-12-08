Return-Path: <linux-kernel-owner+w=401wt.eu-S934660AbZLHDG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934660AbZLHDG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 22:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934184AbZLHDG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 22:06:28 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:33251 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934086AbZLHDG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 22:06:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FoMzF7iz3IiJont5MFSSuPYOnn1w/0hhOk9HmDJd+qcmBVDZc0e3OGF4earb6YXiMg
         YWYnZcCqEJbP2sW1sHbh3zQ0ZjHU2GH+79T4/cnLo4f/7buk7jxzNdZq/WMDSomxxWC9
         SpVESYuJyfQqrZPSnEaiIp6aIjKnI0nYCkD58=
Message-ID: <4B1DC2B6.5080004@gmail.com>
Date: Mon, 07 Dec 2009 21:06:30 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091203 Fedora/3.0-3.13.rc2.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "Jacques, Hugo" <Hugo.Jacques@verint.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Error in SEND(2) man page ?
References: <579B119545DAEF4689C8FBEEFEC5793F01FA2F6FC6C8@ATLMBX.verint.corp.verintsystems.com>
In-Reply-To: <579B119545DAEF4689C8FBEEFEC5793F01FA2F6FC6C8@ATLMBX.verint.corp.verintsystems.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2009 12:43 PM, Jacques, Hugo wrote:
>
> Hi,
>
> I think I found a discrepancy between the man page of send()and the actual implementation.
>
> Man page mentions that:
>
> "[...] When the message does not fit into the send buffer of the socket, send() normally blocks, unless the socket has been placed in non-blocking I/O mode. In non-blocking mode it would fail with the error EAGAIN or EWOULDBLOCK in this case.  [...]"
>
> This tells me that if doing a send() on a tcp non-blocking socket whose send buffer is full, the call should return with -1 and errno=EAGAIN.
>
> But running a trivial test app (code below), send() will indicate (return value) that is sent some but not all of the data buffer when the socket's send buffer is full.
>
> Am I missing anything?
> Is the man page or the code wrong?

I think the man page would be right for a datagram (ex: UDP) socket, but 
not for a stream (ex: TCP) socket, as a stream socket has no real 
concept of "messages".
