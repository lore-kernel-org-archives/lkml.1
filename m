Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbZEDNso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbZEDNso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 09:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbZEDNsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 09:48:35 -0400
Received: from ecserv7.uwaterloo.ca ([129.97.50.127]:55492 "EHLO
	ecserv7.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbZEDNsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 09:48:35 -0400
Message-ID: <20090504093254.196227ivc4tb4k9w@www.nexusmail.uwaterloo.ca>
Date: Mon, 04 May 2009 09:32:54 -0400
From: Elad Lahav <elahav@cs.uwaterloo.ca>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Elad Lahav <elahav@uwaterloo.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Implementation of the sendgroup() system call
References: <49FE47A1.7070700@uwaterloo.ca>
	<49FE9C8C.6090705@cosmosbay.com>
In-Reply-To: <49FE9C8C.6090705@cosmosbay.com>
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

> ie using a different syscall to setup the group (and compute/lookup  
> all needed routes)
>   (this syscall would be able to add/delete members (with their  
> footer/header) to socket group)
This was the original implementation, but it turned out to be less  
effective for several reasons:
1. Groups that change frequently result in too many system calls for  
managing the group (think of users joining and leaving a live  
broadcast);
2. Allowing the caller to maintain the group is more flexible than  
having the kernel responsible for it;
3. No support for per-call per-recipient data.

Point 3 is useful in some scenarios, such as multiplayer online games,  
where the bulk of the data is shared, but each player also receives a  
small chunk of dedicated information.

--Elad




