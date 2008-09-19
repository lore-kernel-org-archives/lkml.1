Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbYISWCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbYISWCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 18:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYISWCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 18:02:11 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:41768 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbYISWCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 18:02:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=WWOtnobG4bRIPd8o6Zm78QC9esDfp5BO6g9ZqhTXrv/jKmcNlxNxIqWjbR7C15niyk
         yiAol9Nxhugd5gxCAUE7BaPBDLrWaP6gYB8JeWLkNx3eC5oAfC0zuZpZldHHPD5TOptA
         E+Zo4J0FJBcZ0bUtQ1p+szw+b1zs0dWQMjEWc=
Message-ID: <84144f020809191502i35805980n97dc3073ab8a52bc@mail.gmail.com>
Date: Sat, 20 Sep 2008 01:02:09 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <cl@linux-foundation.org>
Subject: Re: [patch 3/3] Increase default reserve percpu area
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, ebiederm@xmission.com,
       travis@sgi.com, herbert@gondor.apana.org.au, xemul@openvz.org
In-Reply-To: <20080919203724.474751340@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080919203703.312007962@quilx.com>
	 <20080919203724.474751340@quilx.com>
X-Google-Sender-Auth: 0a1a6210ce833d56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 11:37 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> SLUB now requires a portion of the per cpu reserve. There are on average
> about 70 real slabs on a system (aliases do not count) and each needs 12 bytes
> of per cpu space. Thats 840 bytes. In debug mode all slabs will be real slabs
> which will make us end up with 150 -> 1800. Give it some slack and add 2000
> bytes to the default size.
>
> Things work fine without this patch but then slub will reduce the percpu reserve
> for modules.

Hmm, shouldn't this be dynamically configured at runtime by
multiplying the number of possible CPUs with some constant?
