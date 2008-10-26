Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbYJZQnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbYJZQnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 12:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbYJZQnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 12:43:07 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:10791 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbYJZQnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 12:43:05 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=yTpIyf-tFmFhxjhwck4A:9 a=dhDuXbIyklh42BAdyrh9xAyo1XcA:4 a=64-k_xsDSSYA:10 a=Wwgkb0oGCWUA:10
Message-ID: <49049E16.1090802@shaw.ca>
Date: Sun, 26 Oct 2008 10:43:02 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: ppak_98@yahoo.com
CC: linux-kernel@vger.kernel.org
Subject: Re: unexpected extra pollout events from epoll
References: <fa.YTdIGxaBsWvyaUnxBGIS1f8F2BM@ifi.uio.no>
In-Reply-To: <fa.YTdIGxaBsWvyaUnxBGIS1f8F2BM@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul P wrote:
> I am programming a server using the epoll interface and have the receive portion of the server working fine, but for some reason as I implement the send portion, I noticed a few things that seem like strange behaviors in the implementation of epoll in the kernel.
> 
> I'm running Opensuse 11 and it has a 2.6.25 kernel.
> 
> The behavior that I can seeing is when I do a full read on an edge triggered fd, for some reason, it seems to be triggering an epollout event after each loop of the read events on a socket. (before I've done any writes at all to the socket)
> 
> This is very strange behavior as I would expect that the epollout event would only be triggered if I did a write and the socket recieved an ack which cleared out the send buffer.
> 
> The documentation on epollout is really sparse, so any help at all from the list would be very much appreciated.  Do I need to manually arm the epollout flag after a write?  I thought this was only necessary for level triggered epoll.
> 
> I was hoping someone more knowledgeable on the subject here might be able to help explain the epollout behavior and whether or not the extra events are normal and if so, what is the traditional way to handle these extra events in an edge triggered scenario.

I'm not too familiar with the edge triggered mode, but you shouldn't be 
requesting EPOLLOUT notifications if you don't care about them (i.e. if 
you are not trying to write anything).
