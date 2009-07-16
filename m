Return-Path: <linux-kernel-owner+w=401wt.eu-S932820AbZGPRLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820AbZGPRLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 13:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932801AbZGPRLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 13:11:49 -0400
Received: from cobra.newdream.net ([66.33.216.30]:46763 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932614AbZGPRLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 13:11:48 -0400
Date: Thu, 16 Jul 2009 10:11:48 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/20] ceph: Ceph distributed file system client v0.10
In-Reply-To: <87hbxcx182.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.64.0907161004080.8026@cobra.newdream.net>
References: <1247693090-27796-1-git-send-email-sage@newdream.net>
 <87hbxcx182.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009, Andi Kleen wrote:
> Sage Weil <sage@newdream.net> writes:
> 
> > This is v0.10 of the Ceph distributed file system client.
> >
> > Changes since v0.9:
> >  - fixed unaligned memory access (thanks for heads up to Stefan Richter)
> >  - a few code cleanups
> >  - MDS reconnect and op replay bugfixes.  (The main milestone here is
> >    stable handling of MDS server failures and restarts, tested by
> >    running various workloads with the servers in restart loops.)
> >
> > What would people like to see for this to be merged into fs/?
> 
> Some more comments in the code probably wouldn't help. e.g. each
> file should have some description at the top what it does.

Will do.

> What I always wonder with new complex networking protocols 
> (which ceph essentially is): has there been some auditing/testing
> what happens when a server feeds unexpected/out of bounds data
> to the client? e.g. a security audit would be good. Otherwise
> you might end up with remote exploits.

There are some macros I use for parsing incoming messages that check the 
message bounds, so there's no danger of walking past the end of the 
message (see decode.h in patch 15/20).

I don't always verify that things like element counts are "sane", though, 
so there's currently the possibility of trying to allocate large chunks of 
memory.  Protecting against that sort of malicious data from the server is 
difficult in general, and I'm not sure what the best approach is.  The 
server needs to be trusted to some extent or another.  Client and server 
authentication isn't implemented yet, but the plan is for the client to 
have a cryptographic key (or keys) to authenticate both itself and the 
server before exchanging any meaningful data.

sage
