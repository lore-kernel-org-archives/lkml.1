Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbZGVVrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbZGVVrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 17:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbZGVVrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 17:47:23 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:60662 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663AbZGVVrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 17:47:22 -0400
Subject: Re: Error mounting FC8 NFS server with 2.6.31-rc3 NFSv4 client.
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andy Adamson <andros@netapp.com>
Cc: Ben Greear <greearb@candelatech.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org
In-Reply-To: <74713B5B-DF7F-4357-AE3A-0F6B44C41116@netapp.com>
References: <4A64EB1F.4000602@candelatech.com>
	 <1248178527.5222.0.camel@heimdal.trondhjem.org>
	 <4A65F184.5060802@candelatech.com>
	 <1248196339.21343.8.camel@heimdal.trondhjem.org>
	 <4A65FCB2.6080903@candelatech.com>
	 <1248199140.21343.17.camel@heimdal.trondhjem.org>
	 <4A660295.9020807@candelatech.com>
	 <1248200897.21343.19.camel@heimdal.trondhjem.org>
	 <4A6609A9.3000504@candelatech.com>
	 <1248211050.21343.38.camel@heimdal.trondhjem.org>
	 <A7103385-4525-4B7B-9CBA-5DBCB99A98F0@netapp.com>
	 <1248294013.5234.35.camel@heimdal.trondhjem.org>
	 <74713B5B-DF7F-4357-AE3A-0F6B44C41116@netapp.com>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 17:47:16 -0400
Message-Id: <1248299236.9202.3.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 4 msgs/h 1 sum rcpts/h 6 sum msgs/h 1 total rcpts 936 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 01F1727DB8767497FF018260CE7F91DFD2D425B3
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 84 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 17:32 -0400, Andy Adamson wrote:
> nfs4_init_session should simply return if the nfs_client cl_cons_state  
> is not NFS_CS_SESSION_INITING.
> I shouldn't be trying to set the session max_resp_sz/max_rqst_sz to  
> the rsize/wsize, but rather to the maximum rsize/wsize supported by  
> the client.
> If the server accepts or increases the max_resp_sz/max_rqst_sz then  
> all is well.
> If the server reduces the max_resp_sz/max_rqst_sz, the maximum rsize/ 
> wsize available for NFSv4.1 partition mounts to the server needs to be  
> reduced accordingly. So the nfs_server rsize/wsize needs to be bound  
> by the session max_resp_sz/max_rqst_sz as well as by the maximum  
> supported size.

Well.... The rsize/wsize is one thing, but how about acls? We simply
don't know how big they may become.

An alternative would be to let the server choose the
max_rqst_sz/max_resp_sz by always requesting the maximum allowed value.

Trond

