Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbYDQGRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbYDQGRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 02:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbYDQGRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 02:17:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:8013 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbYDQGRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 02:17:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=unY+wJw8/FEHizr2f836J3v3DfSb1txfchkmZaGXygk3KTiaBJQ3q/y1Nz07PTBRdRjuSAcKbKRs11r6flzxn37jgEvpXRYGxDkYeN3g10SSmncp9jqKEySYlT3Eo4D80AALBhYheyN4NOJWK3rCOKYgoWXwMN8sThg2yoOB0yE=
Message-ID: <e2e108260804162317s5162a6cds151bba6abf988921@mail.gmail.com>
Date: Thu, 17 Apr 2008 08:17:31 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Marc Perkel" <mperkel@yahoo.com>
Subject: Re: AMD Quad Core clock problem?
Cc: "Chris Snook" <csnook@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <414144.49021.qm@web52506.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e2e108260804142311r7ca31d29m7221ca8935a79f35@mail.gmail.com>
	 <414144.49021.qm@web52506.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 11:44 PM, Marc Perkel <mperkel@yahoo.com> wrote:
>  --- Bart Van Assche <bart.vanassche@gmail.com> wrote:
>  > It's better to correct the clock frequency once with
>  > the tickadj or adjtimex, so you don't have to add
>  > ntpdate to cron and you can still run ntpd.
>  >
>  > Bart.
>
>  ok - thanks. How do I do that?

You can do that as follows:
* First of all, make sure that adjtimex is installed. Some distro's
include this command in util-linux.
* Query the current tick value via adjtimex -p | grep tick. E.g. with
HZ = 100, tick == 10000.
* Multiply the tick value with the relative clock error: when e.g. 3s
are lost every hour, the correct tick value is 10000 * (1 + 3/3600) =
10008.
* Pass this new tick value to the kernel via adjtimex -t 10008.
* Stop and restart ntpd such that it forgets any previous frequency estimates.
* Keep an eye on the output of adjtimex -p|grep frequency to see
whether the frequency estimate converges (should be stable within 10
ppm after an hour. See also man adjtimex for the units of this value).

Bart.
