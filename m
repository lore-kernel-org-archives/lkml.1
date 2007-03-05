Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbXCEQbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbXCEQbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbXCEQbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:31:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbXCEQbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:31:42 -0500
Message-ID: <45EC45E1.3090606@redhat.com>
Date: Mon, 05 Mar 2007 11:31:29 -0500
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061215)
MIME-Version: 1.0
To: Andy Chittenden <andyc@bluearc.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Nfs over tcp retries
References: <0F10A59FDFFDFD4E9BEBD7365DE672559C654F@uk-email.terastack.bluearc.com>
In-Reply-To: <0F10A59FDFFDFD4E9BEBD7365DE672559C654F@uk-email.terastack.bluearc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Chittenden wrote:
> Here's a sequence of packets captured at the end of a NFS connection and
> the start of the next for a RH Fedora Core 6 client:
>
> # cat ~/tmp/28852a.txt
> ...
>
> As you can see in packet 3, the nfs server's sent a FIN-ACK which is
> acknowledged in packet 6 by the client. So by packet 8, the connection's
> closed. The client attempts to reconnect to the server in packet 8 which
> is refused by the server in packet 9 as the client is using the same
> port number as the previous session: the server's in TIME WAIT from the
> previous connection and the initial send sequence number of this new
> connection is below the highest sequence number of the previous
> connection. The client's attempts to reconnect continue unsuccessfully
> until 2MSL is exceeded.
>
> So, a few questions:
>
> * why does the NFS client reuse the same source port number (894 in the
> example above)?
> * if the socket's being reused, why is the ISS being chosen such that
> it's within the same range as the last successful connection?
> * why does the ISS seem to go up by only 3 since the last attempt to
> connect?
>
> If the linux NFS client had used a different source port number or
> chosen an out-of-range ISS, then its reconnection attempts would have
> been successful in a more timely manner.

I suspect that the NFS client attempts to reuse the same port number
for the new connection so that it does not invalidate the duplicate
request cache on the server.  NFS servers typically use the entire
IP address of the client, including the port number, when performing
the tests to check to see if the current request is the duplicate of
a previous request.

       ps
