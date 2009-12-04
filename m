Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbZLDAVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbZLDAVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 19:21:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbZLDAVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 19:21:12 -0500
Received: from 220-245-30-18.static.tpgi.com.au ([220.245.30.18]:33445 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223AbZLDAVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 19:21:11 -0500
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Dec 2009 19:21:11 EST
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Joshua Brindle <method@manicmethod.com>
Subject: Re: [PATCH] Dynamic port labeling V2
Date: Fri, 4 Dec 2009 11:12:41 +1100
User-Agent: KMail/1.9.9
Cc: Paul Nuzzi <pjnuzzi@tycho.ncsc.mil>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, jmorris@namei.org,
       selinux@tycho.nsa.gov, "George S. Coker, II" <gscoker@alpha.ncsc.mil>,
       Eamon Walsh <ewalsh@tycho.nsa.gov>, Stephen Smalley <sds@tycho.nsa.gov>
References: <1259616460.2444.9.camel@moss-stripedbass.epoch.ncsc.mil> <4B181228.6080600@manicmethod.com>
In-Reply-To: <4B181228.6080600@manicmethod.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912041112.56570.russell@coker.com.au>
X-Truedomain-SPF: Pass
X-Truedomain-DKIM: Pass
X-Truedomain-Domain: coker.com.au
X-Truedomain: True
X-Truedomain-Logo: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAIAAACQkWg2AAAACXBIWXMAAA2wAAANsAF9ZVn6AAAAB3RJTUUH1wMaDCcChjphMQAAAmRJREFUKM9tkrtPVFEQxuecc+/dR3aB5SW7iLqJPIyKsIiaKFBgIkIjFjY2uonhkVCpiBgSWwz4N4jE2FlYaUIgBJqNuNiKD1RwEV11dV/ce87csbgsUPhliim+30zxfUBEdkGcG5wLzjXONcNw67qLc/32rRF7jzgRQUE+nyd8KMw593o9ra0tNftrGNDC4uKuA4AXFgKA6LXo5OS4rmsjwzcHB/sH+q8DsETiG/wPYACQ/PP72dOpqz2VAff3gb6h0vJ9AGCZyPYAGgABMGLISLjMxJXW100nLel+efChkTYXgdmp1A8iYNsQcec2IwEAIR5rqpd6kTfgp/qg6c8/9+oupZDtvmDcspRlStOyACC+WfdqpXh9RS29+LmxGTHL7zGX3n3xfDR6w9ySliktSzFEAiAgNjZ2H9nWhTON6cSCUVR1uPnSgXBD7+XemZlZzrRYLHbs+FEAAERCRXOzC7W1RzKZzNrXj/H4UjKZVLZC21pejgshhNDb2zotExEJUNmfVtcqK0ITExNoK0SlpGXbyraljTKfy4VCISE0wV39fUNK2qCU3dHeaeiu6enHmczfXC6TSv1SykxnUtBF0EV3hu/6fEWG4RHCPfXoCayvbZQUl7W1ncvns0pJRIloOeMAH96/ratrCAZDQmiNjS3wYHwyECidn59DlIhSShNROta9U11dU1ZWIYQLTp86G4lEHB+izGbTzu34m7zXI7weEV/OQxcJoZeUlHKu8c9fVnt6ulkhG6WUE6WwU9l3uJMpESEqAND8fk8wGNoBiMjp74nRKgCCDmgeBQDgfLug/wCLtk8dVedTHQAAAABJRU5ErkJggg==
X-Truedomain-Sender: PGEgaHJlZj0iaHR0cDovL3RydWVkb21haW4ubmV0LyI+VHJ1ZWRvbWFpbjwvYT4gdmVyaWZpZWQgdGhpcyBlbWFpbCB3YXMgc2VudCBmcm9tIFJ1c3NlbGwgQ29rZXI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Dec 2009, Joshua Brindle <method@manicmethod.com> wrote:
> Aside from the conversation Dave and Casey are having I still think this
> isn't quite right. First, while you can atomically change a single port
> label with the add command above you can't atomically change multiple
> entries, which I think is completely necessary (you don't want to have
> strange labeling states when changing a set of ports to a new label.

Why is it necessary to change multiple ports at the same time?

We support atomic changes of multiple booleans at the same time due to 
possible interactions between them.  But I don't think that we have any such 
issues with port contexts.

> Also, while having a text parser in the kernel makes it easier to use
> with echo I think it is alot of code in the kernel for no good reason.
> There is no reason not to make a userspace tool that converts the
> textual representation into a serialized struct and feed it to the
> kernel. We typically tell users not to mess around in /selinux anyway,
> since we have a libselinux interface to do that.

It does seem likely that significant code complexity can be avoided by not 
having a plain text interface in this case.

-- 
russell@coker.com.au
http://etbe.coker.com.au/          My Main Blog
http://doc.coker.com.au/           My Documents Blog
