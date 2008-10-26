Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbYJZOmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbYJZOmw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 10:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbYJZOmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 10:42:45 -0400
Received: from web56305.mail.re3.yahoo.com ([216.252.110.229]:46007 "HELO
	web56305.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754687AbYJZOmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 10:42:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=xYXgUlCUUooMa2tszBXTqepJIrP4QBm2sTU5ryIU39GDm+ZVRFwlj362XrVLEl465FpNJt3jcEY0kJVxQrlK3JkYMLmQwIZWRd1xuPtLSqnoZJaJ3E1Pg+z+g7pVNDkab6eXAaA153KFPpMP6+f4zEPp4xMIMx7ZCqDgP3DRJ7M=;
X-YMail-OSG: r1BdH.YVM1mFYsebowoSo0WktSePlQAN8bG1UxUXxgByug2o2lWhFL1SnG.KY325ei4wSl3jm5BzsE3NMeK9yfo4R09ymas7pLSbxthEYVvzcrR61TrSLgezXMfy4w0qV3qDpBfimx4YtvYWpRZhNSGFvuok6ei2y1qULbM-
X-Mailer: YahooMailWebService/0.7.247.3
Date: Sun, 26 Oct 2008 07:42:42 -0700 (PDT)
From: Paul P <ppak_98@yahoo.com>
Reply-To: ppak_98@yahoo.com
Subject: unexpected extra pollout events from epoll
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <401776.11819.qm@web56305.mail.re3.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am programming a server using the epoll interface and have the receive portion of the server working fine, but for some reason as I implement the send portion, I noticed a few things that seem like strange behaviors in the implementation of epoll in the kernel.

I'm running Opensuse 11 and it has a 2.6.25 kernel.

The behavior that I can seeing is when I do a full read on an edge triggered fd, for some reason, it seems to be triggering an epollout event after each loop of the read events on a socket. (before I've done any writes at all to the socket)

This is very strange behavior as I would expect that the epollout event would only be triggered if I did a write and the socket recieved an ack which cleared out the send buffer.

The documentation on epollout is really sparse, so any help at all from the list would be very much appreciated.  Do I need to manually arm the epollout flag after a write?  I thought this was only necessary for level triggered epoll.

I was hoping someone more knowledgeable on the subject here might be able to help explain the epollout behavior and whether or not the extra events are normal and if so, what is the traditional way to handle these extra events in an edge triggered scenario.

Thanks!

Paul


      
