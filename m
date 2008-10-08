Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbYJHB4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbYJHB4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 21:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbYJHB4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 21:56:32 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24187 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbYJHB4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 21:56:31 -0400
Message-ID: <48EC1359.6040109@oracle.com>
Date: Wed, 08 Oct 2008 09:56:41 +0800
From: Tiger Yang <tiger.yang@oracle.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.com>
CC: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 13/39] ocfs2: Add extended attribute support
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>	<1222293680-15451-14-git-send-email-mfasheh@suse.com>	<20081002081644.GB24717@lst.de> <20081007220811.GG26373@wotan.suse.de>
In-Reply-To: <20081007220811.GG26373@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Fasheh wrote:
>>> +static inline struct xattr_handler *ocfs2_xattr_handler(int name_index)
>>> +{
>>> +	struct xattr_handler *handler = NULL;
>>> +
>>> +	if (name_index > 0 && name_index < OCFS2_XATTR_MAX)
>>> +		handler = ocfs2_xattr_handler_map[name_index];
>>> +
>>> +	return handler;
>>> +}
>> You seem to need the handler mostly for getting back to the prefix
>> from the handler.  This is a pretty clear indicator that you don't
>> want to use the xattr_handler splitting but deal with the whole
>> attr name.  Take a look at the btrfs code after my recent xattr changes
>> on how to handle this more nicely.
> 
> Tao, Can you look into this?

I have looked the patch for btrfs about this. We are different.
Btrfs store the whole xattr name including the prefix "user." 
"trusted.", we store index number instead of it.

regards,
tiger
