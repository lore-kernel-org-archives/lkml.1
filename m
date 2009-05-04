Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbZEDNpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbZEDNpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 09:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbZEDNph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 09:45:37 -0400
Received: from ecserv7.uwaterloo.ca ([129.97.50.127]:53661 "EHLO
	ecserv7.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbZEDNpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 09:45:36 -0400
X-Greylist: delayed 743 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 May 2009 09:45:36 EDT
Message-ID: <20090504094431.174745mb0jhhm3s4@www.nexusmail.uwaterloo.ca>
Date: Mon, 04 May 2009 09:44:31 -0400
From: Elad Lahav <elahav@cs.uwaterloo.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: Elad Lahav <elahav@uwaterloo.ca>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] Implementation of the sendgroup() system call
References: <49FE47A1.7070700@uwaterloo.ca>
	<87eiv5ibnd.fsf@basil.nowhere.org>
In-Reply-To: <87eiv5ibnd.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.2) / FreeBSD-6.3
X-Originated-By: elahav@mail.cs.uwaterloo.ca
X-Originating-IP: 208.65.73.114
X-Remote-Browser: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US;
	rv:1.9.0.10) Gecko/2009042316 Firefox/3.0.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My guess it's more the copies than the calls?
It's a factor of both. This is why we also created the sendgroup()  
implementation that uses a tight loop of in-kernel calls to sendmsg()  
as a means for evaluating the cost of mode switches. It is definitely  
not negligible (exact numbers depend on the size of the group and the  
size of the payload, of course).

> It sounds like you want sendfile() for UDP.
Do you mean by having a per-recipient sendfile() call for the same  
file? Leaving the cost of the system call aside, this solution does  
not work well with the kind of real-time data that we've been working  
with (live streaming, online games). You would have to write the  
payload to the file as it is being generated and call sendfile() after  
each such write.

--Elad




