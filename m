Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbZCGRdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbZCGRdL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 12:33:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbZCGRc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 12:32:57 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:53487 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbZCGRc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 12:32:56 -0500
Date: Sat, 7 Mar 2009 09:31:29 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, hpa@zytor.com, hch@lst.de,
       sukadev@us.ibm.com, Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [v2][PATCH 2/5] Parse mount options just once and copy them to
	super block
Message-ID: <20090307173129.GA29293@us.ibm.com>
References: <20090204043516.GB25963@us.ibm.com> <20090204043705.GB26202@us.ibm.com> <20090205001010.GC17354@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205001010.GC17354@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I had not responded to this:

Serge E. Hallyn [serue@us.ibm.com] wrote:
| > -	if (new)
| > -		return new_pts_mount(fs_type, flags, data, mnt);
| > +	memset(&opts, 0, sizeof(opts)); 
| > +	if (data) {
| > +		error = parse_mount_options(data, PARSE_MOUNT, &opts);
| 
| Is there any reason to keep the PARSE_MOUNT argument to
| parse_mount_options?

Yes parse_mount_options() needs to know whether it is a MOUNT or 
REMOUNT operation - MOUNT operation should clear 'newinstance' to
default before parsing, but REMOUNT should not.
