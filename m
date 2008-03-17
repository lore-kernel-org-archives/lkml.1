Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbYCQKsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbYCQKsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 06:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbYCQKsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 06:48:30 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:36007
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbYCQKs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 06:48:29 -0400
Message-ID: <47DE4C7A.9030208@qumranet.com>
Date: Mon, 17 Mar 2008 12:48:26 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Roland Dreier <rdreier@cisco.com>,
       Davide Libenzi <davidel@xmailserver.org>, linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH/RFC 1/2] anon-inodes: Remove fd_install() from anon_inode_getfd()
References: <20080225191043.GA32342@lst.de> <adak5kqyzv1.fsf@cisco.com> <Pine.LNX.4.64.0802271138170.377@alien.or.mcafeemobile.com> <adabq62yx5r.fsf@cisco.com> <Pine.LNX.4.64.0802271218210.377@alien.or.mcafeemobile.com> <ada7igqyurw.fsf@cisco.com> <adar6eyx8y5.fsf@cisco.com> <20080306151402.GA17077@lst.de> <ada4pbgsjht.fsf@cisco.com> <20080317104025.GA9663@lst.de>
In-Reply-To: <20080317104025.GA9663@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Sat, Mar 08, 2008 at 06:45:34PM -0800, Roland Dreier wrote:
>   
>>  >  	spin_lock(&kvm_lock);
>>  > +	if (--kvm->refcount) {
>>  > +		spin_lock(&kvm_lock);
>>
>> obvious typo here...
>>     
>
>   












> Indeed.  Any comments from the kvm developers in this approach?  The
> current multi-level file refcounting seems rather bogus so I'd like
> to make some progress on this.
>
>   

I'm okay with switching away from the file-based refcounts to a refcount 
embedded in the kvm structures, though I'm not particularly thrilled by 
it.  Any reason not to use krefs for this?

-- 
error compiling committee.c: too many arguments to function

