Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYCMMgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYCMMgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 08:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYCMMfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:35:55 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:46897 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbYCMMfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:35:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=liXuREJDUDWsCpiSa/5obOtFCB5m8CZdLM91SX2LPz0Kuqe7okaAGvXu4x9yqbcDwMOIWomifB33mp0Cnvntq6nCq8hb/lWZRiDTgSMbCsXTwcbJ/beIoQ+hvuj31AQDac6hrzYXtJqjOAHMuY08EJUAcuA6J1CqgKEHdqgn6vk=
Message-ID: <e9e943910803130535t4c31ea51h6898545557c9ec0c@mail.gmail.com>
Date: Thu, 13 Mar 2008 12:35:53 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "Daniel Phillips" <phillips@phunq.net>
Subject: Re: [RFC, PATCH 0/6] ext3: do not modify data on-disk when mounting read-only filesystem
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Theodore Tso" <tytso@mit.edu>, sct@redhat.com,
       akpm@linux-foundation.org, adilger@clusterfs.com
In-Reply-To: <200803122022.22814.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204768754-29655-1-git-send-email-duaneg@dghda.com>
	 <200803122022.22814.phillips@phunq.net>
X-Google-Sender-Auth: 319dc5abfeabac6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/03/2008, Daniel Phillips <phillips@phunq.net> wrote:
> Hi Duane,
>
>  Thanks for doing this.  Some perhaps not so obvious fallout from the bad
>  old way of doing things is that ddnap (zumastor) hits an issue in
>  replication.  Since ddsnap allows journal replay on the downstream
>  server and also needs to have an unaltered snapshot to apply deltas
>  against, if we do not take special care, Ext3 will come along and
>  modify the downstream snapshot even when told not to.  Our solution:
>  take two snapshots per replication cycle (pretty cheap) so that one can
>  be clean and the other can be stepped on at will by the journal replay.
>  Ugh.

Ah, good to know, thanks. It looks like you folks are doing some
interesting things there.

>  With your hack, we can eventually drop the double snapshot, provided no
>  other filesystem is similarly badly behaved.

Excellent, I'm really pleased to hear that.

>  Re your page translation table: we already have a page translation
>  table, it is called the page cache.  If you could figure out which file
>  (or metadata) each journal block belongs to, you could just load the
>  page table pages back in and presto, done.  No need to replay the
>  journal at all, you are already back to journal+disk = consistent
>  state.

Hmm, interesting. I'll have to have a think about that, thanks.

>  mapping.  As it stands your solution seems well built, after a quick
>  readthrough.  Nice looking code.  I think you added about 250 lines
>  overall, so tight too.  Thanks again.

Thanks very much, I appreciate it!

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
