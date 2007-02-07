Return-Path: <linux-kernel-owner+w=401wt.eu-S1422689AbXBGTG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422689AbXBGTG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 14:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422710AbXBGTG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 14:06:58 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51260 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422689AbXBGTG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 14:06:57 -0500
Date: Wed, 7 Feb 2007 19:06:32 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>,
       jack@suse.cz, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove sb->s_files and file_list_lock usage in dquot.c
Message-ID: <20070207190632.GA3350@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070206132333.GA9919@lst.de> <20070206155001.22ab74f6.akpm@linux-foundation.org> <20070207072259.GA22083@lst.de> <Pine.LNX.4.61.0702071901150.20245@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0702071901150.20245@yvahk01.tjqt.qr>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 07:03:05PM +0100, Jan Engelhardt wrote:
> With filesystems that can turn on their quota after mount time (about 
> every fs except xfs), I can surely have a ton of files open, and hence, 
> if I understand correctly, have lots of inodes instantiated.

Yes, you can in theory.  But turning on quota on a filesystem in full
steam useage is not a common use case and thus there is no point in
optimizing for it.

